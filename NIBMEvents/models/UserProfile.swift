//
//  User.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation

struct UserProfile {
    var uid: String
    var firstName: String
    var lastName: String
    var profileImageUrl: String
    var contactNumber: String
    var facebookIdentifier: String
    var batch: String

    init?(user: [String: Any]) {
        guard let uid = user["uid"] as? String,
            let firstName = user["firstName"] as? String,
            let lastName = user["lastName"] as? String,
            let profileImageUrl = user["profileImageUrl"] as? String,
            let contactNumber = user["contactNumber"] as? String,
            let facebookIdentifier = user["facebookIdentifier"] as? String,
            let batch = user["batch"] as? String
            else { return nil }

        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageUrl = profileImageUrl
        self.contactNumber = contactNumber
        self.facebookIdentifier = facebookIdentifier
        self.batch = batch
    }
}
