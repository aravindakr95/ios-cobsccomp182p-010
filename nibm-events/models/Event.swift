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
    var eventId: String
    var timeStamp: Timestamp
    var publisher: String
    var publisherImageUrl: String
    var publisherBatch: String
    var body: String
    var eventImageUrl: String
    var likesCount: Int
    
    init?(event: [String: Any]) {
        guard let uid = event["uid"] as? String,
            let eventId = event["eventId"] as? String,
            let timeStamp = event["timeStamp"] as? Timestamp,
            let publisher = event["publisher"] as? String,
            let publisherImageUrl = event["publisherImageUrl"] as? String,
            let publisherBatch = event["publisherBatch"] as? String,
            let body = event["body"] as? String,
            let eventImageUrl = event["eventImageUrl"] as? String,
            let likesCount = event["likesCount"] as? Int else { return nil }
        
        self.uid = uid
        self.eventId = eventId
        self.timeStamp = timeStamp
        self.publisher = publisher
        self.publisherImageUrl = publisherImageUrl
        self.publisherBatch = publisherBatch
        self.body = body
        self.eventImageUrl = eventImageUrl
        self.likesCount = likesCount
    }
}
