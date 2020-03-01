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
    var publishedLocation: String
    var publisherFacebookIdentifier: String
    
    init?(publisher: [String: String]) {
        guard let publisherName = publisher["publisher"],
            let publisherImageUrl = publisher["publisherImageUrl"],
            let publisherBatch = publisher["publisherBatch"],
            let publishedLocation = publisher["publishedLocation"],
            let publisherFacebookIdentifier = publisher["publisherFacebookIdentifier"] else { return nil }
        
        self.publisherName = publisherName
        self.publisherImageUrl = publisherImageUrl
        self.publisherBatch = publisherBatch
        self.publishedLocation = publishedLocation
        self.publisherFacebookIdentifier = publisherFacebookIdentifier
        self.publisherFacebookIdentifier = publisherFacebookIdentifier
    }
    
    init() {
        self.publisherName = ""
        self.publisherImageUrl = ""
        self.publisherBatch = ""
        self.publishedLocation = ""
        self.publisherFacebookIdentifier = ""
    }
}
