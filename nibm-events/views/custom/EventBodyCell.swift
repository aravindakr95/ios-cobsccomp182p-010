//
//  EventBodyCell.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import Kingfisher

class EventBodyCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var numberOfLikesButton: UIButton!
    
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    var event: Event! {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        let imgUrl = URL(string: event.eventImageUrl)
        self.postImageView.kf.indicatorType = .activity
        self.postImageView.kf.setImage(with: imgUrl)
        
        self.postCaptionLabel.text = event.body
        self.numberOfLikesButton.setTitle(updateLikeCount(), for: [])
        
        
        self.timeAgoLabel.text = Date.timeAgo(event.timeStamp.dateValue())()
    }
    
    private func updateLikeCount() -> String {
        if (event.likesCount > 0) {
            return "\u{2665} \(event.likesCount) Likes"
        } else {
            return "Be the first one to like this"
        }
    }
}
