//
//  Publisher.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 3/1/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation

struct Publisher {
    var publisherName: String
    var publisherImageUrl: String
    var publisherBatch: String
    var publisherFacebookIdentifier: String
    var publisherContactNumber: String
    
    init?(publisher: [String: String]) {
        guard let publisherName = publisher["publisher"],
            let publisherImageUrl = publisher["publisherImageUrl"],
            let publisherBatch = publisher["publisherBatch"],
            let publisherFacebookIdentifier = publisher["publisherFacebookIdentifier"],
            let publisherContactNumber = publisher["publisherContactNumber"]
            else { return nil }
        
        self.publisherName = publisherName
        self.publisherImageUrl = publisherImageUrl
        self.publisherBatch = publisherBatch
        self.publisherFacebookIdentifier = publisherFacebookIdentifier
        self.publisherContactNumber = publisherContactNumber
    }
}
