//
//  Post.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation
import CoreLocation

import FirebaseFirestore

struct Event {
    var uid: String?
    var documentId: String?
    var timeStamp: Timestamp
    var title: String
    var publisher: String?
    var publisherImageUrl: String?
    var publisherBatch: String?
    var publishedLocation: String?
    var publisherFacebookIdentifier: String?
    var publisherContactNumber: String?
    var coordinates: GeoPoint?
    var body: String
    var eventImageUrl: String
    var isGoing: Bool

    init?(event: [String: Any], docId: String?) {
        guard let uid = event["uid"] as? String,
            let documentId = docId,
            let timeStamp = event["timeStamp"] as? Timestamp,
            let title = event["title"] as? String,
            let publisher = event["publisher"] as? String,
            let publisherImageUrl = event["publisherImageUrl"] as? String,
            let publisherBatch = event["publisherBatch"] as? String,
            let publishedLocation = event["publishedLocation"] as? String,
            let publisherFacebookIdentifier = event["publisherFacebookIdentifier"] as? String,
            let publisherContactNumber = event["publisherContactNumber"] as? String,
            let coordinates = event["coordinates"] as? GeoPoint,
            let body = event["body"] as? String,
            let eventImageUrl = event["eventImageUrl"] as? String,
            let isGoing = event["isGoing"] as? Bool else { return nil }

        self.uid = uid
        self.documentId = documentId
        self.timeStamp = timeStamp
        self.title = title
        self.publisher = publisher
        self.publisherImageUrl = publisherImageUrl
        self.publisherBatch = publisherBatch
        self.publishedLocation = publishedLocation
        self.publisherFacebookIdentifier = publisherFacebookIdentifier
        self.publisherContactNumber = publisherContactNumber
        self.coordinates = coordinates
        self.body = body
        self.eventImageUrl = eventImageUrl
        self.isGoing = isGoing
    }
}
