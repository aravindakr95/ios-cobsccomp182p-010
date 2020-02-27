//
//  EventHeaderCell.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class EventHeaderCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var event: Event! {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        let imgUrl = URL(string: event.publisherImageUrl)
        self.profileImageView.kf.indicatorType = .activity
        self.profileImageView.kf.setImage(with: imgUrl)
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        
        usernameLabel.text = event.publisher
        
        followButton.layer.borderWidth = 1.0
        followButton.layer.cornerRadius = 2.0
        followButton.layer.borderColor = followButton.tintColor.cgColor
        followButton.layer.masksToBounds = true
    }
    
}
