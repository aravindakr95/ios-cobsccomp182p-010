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
    @IBOutlet weak var btnGoingPreference: NECustomSwipButton!
    @IBOutlet weak var btnGoingStatus: UIButton!
    
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
        self.btnGoingStatus.setTitle(isParticipate(), for: .normal)
        
        let now = Date()
        self.lblPostTimeAgo.text = now.timeAgo()
    }
    
    private func isParticipate() -> String {
        if (event.isGoing) {
            self.btnGoingStatus.tintColor = #colorLiteral(red: 0.4431372549, green: 0.831372549, blue: 0.6039215686, alpha: 1)
            self.btnGoingStatus.setTitleColor(#colorLiteral(red: 0.4431372549, green: 0.831372549, blue: 0.6039215686, alpha: 1), for: .normal)
            return "Going"
        } else {
            self.btnGoingStatus.tintColor = #colorLiteral(red: 1, green: 0.4941176471, blue: 0.4745098039, alpha: 1)
            self.btnGoingStatus.setTitleColor(#colorLiteral(red: 1, green: 0.4941176471, blue: 0.4745098039, alpha: 1), for: .normal)
            return "Not Going"
        }
    }
}
