//
//  EventHeaderCell.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class EventHeaderCell: UITableViewCell {
    @IBOutlet weak var imgProfileView: UIImageView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var btnBatch: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    
    var event: Event! {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        let imgUrl = URL(string: event.publisherImageUrl!)
        
        self.imgProfileView.kf.indicatorType = .activity
        self.imgProfileView.kf.setImage(with: imgUrl)
        
        self.imgProfileView.layer.cornerRadius = imgProfileView.bounds.width / 2.0
        self.imgProfileView.layer.masksToBounds = true
        
        self.lblEventName.text = event.title

        self.btnBatch.layer.borderWidth = 1.0
        self.btnBatch.layer.cornerRadius = 2.0
        self.btnBatch.layer.borderColor = btnBatch.tintColor.cgColor
        self.btnBatch.layer.masksToBounds = true
        
        self.btnBatch.setTitle(event.publisherBatch, for: .normal)
        self.lblLocation.text = event.publishedLocation
    }
}
