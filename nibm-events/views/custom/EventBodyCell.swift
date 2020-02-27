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
        self.btnLikesCount.setTitle(isParticipate(), for: [])
        
        
        self.lblPostTimeAgo.text = Date.timeAgo(event.timeStamp.dateValue())()
    }
    
    private func isParticipate() -> String {
        if (event.isGoing) {
            return "\u{2714} Going"
        } else {
            return "\u{274C} Not Going"
        }
    }
}
