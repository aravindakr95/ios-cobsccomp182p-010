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
    @IBOutlet weak var imgPostView: UIImageView!
    
    @IBOutlet weak var btnLikesCount: UIButton!
    
    @IBOutlet weak var lblPostBody: UILabel!
    @IBOutlet weak var lblPostTimeAgo: UILabel!
    
    var event: Event! {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI() {
        let imgUrl = URL(string: event.eventImageUrl)
        self.imgPostView.kf.indicatorType = .activity
        self.imgPostView.kf.setImage(with: imgUrl)
        
        self.lblPostBody.text = event.body
        self.btnLikesCount.setTitle(updateLikeCount(), for: [])
        
        
        self.lblPostTimeAgo.text = Date.timeAgo(event.timeStamp.dateValue())()
    }
    
    private func updateLikeCount() -> String {
        if (event.likesCount > 0) {
            return "\u{2665} \(event.likesCount) Likes"
        } else {
            return "Be the first one to like this"
        }
    }
}
