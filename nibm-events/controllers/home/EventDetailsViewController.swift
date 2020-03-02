//
//  EventDetailsViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 3/2/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.updateUI()
    }
    
//    private func updateUI() {
//        self.profile = Publisher(publisher: UserDefaults.standard.value(forKey: "selectedProfile") as! [String: String])
//        guard let profile = profile else { return }
//        let imgUrl = URL(string: profile.publisherImageUrl)
//        self.profileImageView.kf.indicatorType = .activity
//        self.profileImageView.kf.setImage(with: imgUrl)
//
//        self.lblFullName!.text = profile.publisherName
//        self.lblBatch!.text = profile.publisherBatch
//        self.lblContactNumber.text = profile.publisherContactNumber
//        self.btnFacebookIdentifier.setTitle(profile.publisherFacebookIdentifier, for: .normal)
//    }
}
