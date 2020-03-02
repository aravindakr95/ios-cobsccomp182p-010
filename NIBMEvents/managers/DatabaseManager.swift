//
//  DatabaseManager.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class DatabaseManager {
    public static let sharedInstance = DatabaseManager()

    private let database: Firestore = Firestore.firestore()
    private let storageRef = Storage.storage().reference()

    private var events = [Event]()

    func insertDocument(collection: String,
                        data: [String: Any],
                        isRegistration: Bool? = false,
                        completion: @escaping (_ success: Bool?, _ error: String?)
        -> Void) {
        if isRegistration! {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }

        self.database.collection(collection).addDocument(data: data) { (error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

    func mergeDocument(collection: String,
                       documentId: String,
                       data: [String: Any],
                       completion: @escaping (_ success: String?, _ error: String?)
        -> Void) {
        self.database.collection(collection).document(documentId).setData(data, merge: true) { (error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                completion("Document succuessfully written.", nil)
            }
        }
    }

    func retrieveDocuments(collection: String,
                           completion: @escaping (_ success: [Event]?, _ error: String?)
        -> Void) {
        self.database.collection(collection).getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot results")
                return
            }
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                let models = snapshot.documents.map { (document) -> Event in
                    return Event(event: document.data(), docId: document.documentID)!
                }

                self.events = models
                completion(models, nil)
            }
        }
    }

    func retrieveDocumentsWhere(finder: String, value: String,  collection: String,
                                completion: @escaping (_ success: [Event]?, _ error: String?)
        -> Void) {
        self.database.collection(collection).whereField(finder, isEqualTo: value).getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot results.")
                return
            }
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                let models = snapshot.documents.map { (document) -> Event in
                    return Event(event: document.data(), docId: document.documentID)!
                }

                self.events = models
                completion(models, nil)
            }
        }
    }
    
    func listenDocumentChangeWhere(finder: String, value: String,  collection: String,
                                   completion: @escaping (_ success: Event?, _ error: String?)
        -> Void) {
        self.database.collection(collection).whereField(finder, isEqualTo: value).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else { return }

            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let dataset = Event(event: diff.document.data(), docId: diff.document.documentID)!
                        self.events.append(dataset)
                        completion(Event(event: diff.document.data(), docId: diff.document.documentID)!, nil)
                    }
                }
            }
        }
    }

    func listenDocumentsChange(collection: String,
                               completion: @escaping (_ success: Event?, _ error: String?)
        -> Void) {
        self.database.collection(collection).whereField("timeStamp", isGreaterThan: Date())
            .addSnapshotListener { (querySnapshot, _ error) in
                guard let snapshot = querySnapshot else { return }

                if let error = error {
                    completion(nil, error.localizedDescription)
                } else {
                    snapshot.documentChanges.forEach { diff in
                        if diff.type == .added || diff.type == .modified {
                            let dataset = Event(event: diff.document.data(), docId: diff.document.documentID)!
                            self.events.append(dataset)
                            completion(dataset, nil)
                        }
                    }
                }
        }
    }

    func uploadImage(image: UIImage,
                     email: String,
                     type: UploadType,
                     completion: @escaping (_ url: String?, _ error: String?)
        -> Void) {
        guard let imageToUpload = image.jpegData(compressionQuality: 0.75) else { return }
        let metaData: StorageMetadata = StorageMetadata()
        metaData.contentType = "image/jpeg"

        var stRef: StorageReference?
        var urlPath: String?

        if (type == .profile) {
            urlPath = "users/\(email)"
            stRef = self.storageRef.child(urlPath!)
        } else {
            urlPath = "events/\(UUID().uuidString)"
            stRef = self.storageRef.child(urlPath!)
        }

        stRef!.putData(imageToUpload, metadata: metaData) { (metaData, uploadError) in
            if metaData != nil , uploadError == nil {
                stRef!.downloadURL(completion: { (url, error) in
                    if error != nil {
                        completion(nil, error?.localizedDescription)
                        return
                    } else {
                        completion(url?.absoluteString , nil)
                    }
                })
            } else {
                completion(nil, uploadError?.localizedDescription)
            }
        }
    }
}
