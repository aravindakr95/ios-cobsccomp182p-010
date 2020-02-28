//
//  DatabaseManager.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation
import Firebase

final class DatabaseManager {
    private let database: Firestore = Firestore.firestore()
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
                    return Event(event: document.data())!
                }
                
                self.events = models
                completion(models, nil)
            }
        }
    }
    
    func listenDocumentChanges(collection: String,
                                      completion: @escaping (_ success: Event?, _ error: String?)
        -> Void) {
        self.database.collection(collection).whereField("timeStamp", isGreaterThan: Date())
            .addSnapshotListener { (querySnapshot, _ error) in
                guard let snapshot = querySnapshot else { return }
                
                if let error = error {
                    completion(nil, error.localizedDescription)
                } else {
                    snapshot.documentChanges.forEach { diff in
                        if diff.type == .added {
                            self.events.append(Event(event: diff.document.data())!)
                            completion(Event(event: diff.document.data())!, nil)
                        }
                    }
                }
        }
    }
}
