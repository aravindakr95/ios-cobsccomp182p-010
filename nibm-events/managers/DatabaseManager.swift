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
    private let database: Firestore = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    
    private var events = [Event]()
    
    public static let sharedInstance = DatabaseManager()
    
    func insertDocument(collection: String,
                        data: [String: String],
                        completion: @escaping (_ success: Bool?, _ error: String?)
        -> Void) {
        
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
                    return Event(event: document.data(), id: document.documentID)!
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
                    return Event(event: document.data(), id: document.documentID)!
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
                    self.events.append(Event(event: diff.document.data(), id: diff.document.documentID)!)
                    completion(Event(event: diff.document.data(), id: diff.document.documentID)!, nil)
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
                        let dataset = Event(event: diff.document.data(), id: diff.document.documentID)!
                        self.events.append(dataset)
                        completion(dataset, nil)
                    }
                }
        }
    }
    
    func uploadImage(image: UIImage,
                     email: String,
                     type: UploadType ,
                     completion: @escaping (_ success: String?, _ error: Bool?)
        -> Void) {
        guard let imageToUpload = image.jpegData(compressionQuality: 0.75) else { return }
        let metaData: StorageMetadata = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        var stRef: StorageReference?
        
        if (type == .event) {
            stRef = self.storageRef.child("users/\(email)")
        } else {
            stRef = self.storageRef.child("events/\(UUID().uuidString)")
        }
        
        stRef!.putData(imageToUpload, metadata: metaData) { (metaData, uploadError) in
            if metaData != nil , uploadError == nil {
                completion("Image successfully inserted to the storage." , true);
            } else {
                completion(uploadError?.localizedDescription , false)
            }
        }
    }
}
