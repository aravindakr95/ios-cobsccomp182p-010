//
//  CustomEvent.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation

struct CustomEvent {
    var documentId: String?
    var title: String?
    var publishedLocation: String?
    var publisherContactNumber: String?
    var body: String?
    var eventImageUrl: String?

    init?(event: [String: Any]) {
        guard
            let documentId = event["documentId"] as? String,
            let title = event["title"] as? String,
            let publishedLocation = event["publishedLocation"] as? String,
            let publisherContactNumber = event["publisherContactNumber"] as? String,
            let body = event["body"] as? String,
            let eventImageUrl = event["eventImageUrl"] as? String else { return nil }

        self.documentId = documentId
        self.title = title
        self.publishedLocation = publishedLocation
        self.publisherContactNumber = publisherContactNumber
        self.body = body
        self.eventImageUrl = eventImageUrl
    }
}
