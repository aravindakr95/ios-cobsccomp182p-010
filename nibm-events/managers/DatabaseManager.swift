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
    let database: Firestore = Firestore.firestore()

    public func insert(collection: String, data: [String: String],
                       completion: @escaping (_ success: Bool?, _ error: String?) -> Void) {
        self.database.collection(collection).addDocument(data: data) { (error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
}
