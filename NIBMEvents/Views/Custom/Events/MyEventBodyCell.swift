//
//  MyEventBodyCell.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/28/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class MyEventBodyCell: UITableViewCell {
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblEventLocation: UILabel!
    @IBOutlet weak var lblEventBody: UILabel!

    var event: Event! {
        didSet {
            self.updateUI()
        }
    }

    private func updateUI() {
        let imgUrl = URL(string: event.eventImageUrl)
        self.imgEvent.kf.indicatorType = .activity
        self.imgEvent.kf.setImage(with: imgUrl)

        self.lblEventBody.text = event.body
        self.lblEventLocation.text = event.publishedLocation
    }
}
