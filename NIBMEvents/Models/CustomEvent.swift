//
//  CustomEvent.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation
import CoreLocation

import FirebaseFirestore

struct CustomEvent {
    var documentId: String?
    var title: String?
    var publishedLocation: String?
    var longitude: Double?
    var latitude: Double?
    var timeStamp: Date?
    var publisherName: String?
    var publisherImageUrl: String?
    var publisherContactNumber: String?
    var body: String?
    var eventImageUrl: String?

    init?(event: [String: Any]) {
        guard
            let documentId = event["documentId"] as? String,
            let title = event["title"] as? String,
            let publishedLocation = event["publishedLocation"] as? String,
            let longitude = event["longitude"] as? Double,
            let latitude = event["latitude"] as? Double,
            let timeStamp = event["timeStamp"] as? Date,
            let publisherContactNumber = event["publisherContactNumber"] as? String,
            let publisherName = event["publisherName"] as? String,
            let publisherImageUrl = event["publisherImageUrl"] as? String,
            let body = event["body"] as? String,
            let eventImageUrl = event["eventImageUrl"] as? String else { return nil }

        self.documentId = documentId
        self.title = title
        self.publishedLocation = publishedLocation
        self.longitude = longitude
        self.latitude = latitude
        self.timeStamp = timeStamp
        self.publisherContactNumber = publisherContactNumber
        self.publisherName = publisherName
        self.publisherImageUrl = publisherImageUrl
        self.body = body
        self.eventImageUrl = eventImageUrl
    }
}
