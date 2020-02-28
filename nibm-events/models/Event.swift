//
//  Post.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation
import Firebase

struct Event {
    var uid: String
    var documentId: String
    var timeStamp: Timestamp
    var publisher: String
    var publisherImageUrl: String
    var publisherBatch: String
    var publishedLocation: String
    var body: String
    var eventImageUrl: String
    var isGoing: Bool
    
    init?(event: [String: Any], id: String) {
        guard let uid = event["uid"] as? String,
            let documentId = id as? String,
            let timeStamp = event["timeStamp"] as? Timestamp,
            let publisher = event["publisher"] as? String,
            let publisherImageUrl = event["publisherImageUrl"] as? String,
            let publisherBatch = event["publisherBatch"] as? String,
            let publishedLocation = event["publishedLocation"] as? String,
            let body = event["body"] as? String,
            let eventImageUrl = event["eventImageUrl"] as? String,
            let isGoing = event["isGoing"] as? Bool else { return nil }
        
        self.uid = uid
        self.documentId = documentId
        self.timeStamp = timeStamp
        self.publisher = publisher
        self.publisherImageUrl = publisherImageUrl
        self.publisherBatch = publisherBatch
        self.publishedLocation = publishedLocation
        self.body = body
        self.eventImageUrl = eventImageUrl
        self.isGoing = isGoing
    }
}
