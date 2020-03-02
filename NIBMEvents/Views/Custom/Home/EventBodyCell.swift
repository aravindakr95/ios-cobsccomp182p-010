//
//  EventBodyCell.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/26/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class EventBodyCell: UITableViewCell {
    @IBOutlet weak var imgPostView: UIImageView!
    
    @IBOutlet weak var btnGoingPreference: NECustomSwipButton!
    
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnGoingStatus: UIButton!
    
    @IBOutlet weak var lblPostBody: UILabel!
    @IBOutlet weak var lblPostTimeAgo: UILabel!
    
    private static let eventPreference: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    static var onEventPreferenceChange: Observable<Bool> {
        return EventBodyCell.eventPreference.asObservable()
    }

    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    var event: Event! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBAction func onGoingPreferenceChange(_ sender: NECustomSwipButton) {
        let status = !sender.isChecked
        if (status) {
            EventBodyCell.eventPreference.onNext(true)
        } else {
            EventBodyCell.eventPreference.onNext(false)
        }

        self.setEventPreference(isGoing: status)
    }
    
    private func updateUI() {
        let isGuest = UserDefaults.standard.bool(forKey: "isGuest")
        if isGuest {
            self.updateUIforGuest()
        }
        
        let imgUrl = URL(string: event.eventImageUrl)
        self.imgPostView.kf.indicatorType = .activity
        self.imgPostView.kf.setImage(with: imgUrl)
        
        self.lblPostBody.text = event.body
        self.lblPostTimeAgo.text = formatter.string(from: event.timeStamp.dateValue())

        if !isGuest {
            self.setEventPreference(isGoing: event.isGoing)
        }
    }
    
    private func updateUIforGuest() {
        self.btnGoingPreference.setImage(UIImage(named: "like-outline"), for: .normal)
        self.btnGoingPreference.isEnabled = false
        
        self.btnComment.isEnabled = false
        self.btnShare.isEnabled = false
        
        self.btnGoingStatus.setTitle("Sign in to update your thoughts", for: .normal)
        self.btnGoingStatus.tintColor = #colorLiteral(red: 1, green: 0.4941176471, blue: 0.4745098039, alpha: 1)
        self.btnGoingStatus.setTitleColor(#colorLiteral(red: 1, green: 0.4941176471, blue: 0.4745098039, alpha: 1), for: .normal)
    }
    
    private func setEventPreference(isGoing: Bool) {
        let likeFill = UIImage(named: "like-fill")
        let likeOutline = UIImage(named: "like-outline")

        if (isGoing) {
            self.btnGoingPreference.setImage(likeFill, for: .normal)
            
            UIView.transition(with: btnGoingStatus, duration: 0.01, options: .transitionFlipFromBottom, animations: {
                self.btnGoingStatus.setTitle("Going", for: .normal)
                self.btnGoingStatus.tintColor = #colorLiteral(red: 0.4431372549, green: 0.831372549, blue: 0.6039215686, alpha: 1)
                self.btnGoingStatus.setTitleColor(#colorLiteral(red: 0.4431372549, green: 0.831372549, blue: 0.6039215686, alpha: 1), for: .normal)
            }, completion: nil)
        } else {
            self.btnGoingPreference.setImage(likeOutline, for: .normal)

            UIView.transition(with: btnGoingStatus, duration: 0.01, options: .transitionFlipFromBottom, animations: {
                self.btnGoingStatus.setTitle("Not Going", for: .normal)
                self.btnGoingStatus.tintColor = #colorLiteral(red: 1, green: 0.4941176471, blue: 0.4745098039, alpha: 1)
                self.btnGoingStatus.setTitleColor(#colorLiteral(red: 1, green: 0.4941176471, blue: 0.4745098039, alpha: 1), for: .normal)
            }, completion: nil)
        }
    }
}
