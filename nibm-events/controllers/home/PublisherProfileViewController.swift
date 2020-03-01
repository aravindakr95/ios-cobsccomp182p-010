//
//  PublisherProfileViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/29/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import Kingfisher

class PublisherProfileViewController: UIViewController {
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblBatch: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    
    var profile: Publisher!
    
    @IBOutlet weak var btnFacebookIdentifier: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    private func updateUI() {
        self.profile = Publisher(publisher: UserDefaults.standard.value(forKey: "selectedEvent") as! [String: String])
        guard let profile = profile else { return }
        let imgUrl = URL(string: profile.publisherImageUrl)
        self.profileImageView.kf.indicatorType = .activity
        self.profileImageView.kf.setImage(with: imgUrl)
        
        self.lblFullName!.text = profile.publisherName
        self.lblBatch!.text = profile.publisherBatch
        self.lblContactNumber.text = profile.publisherContactNumber
        self.btnFacebookIdentifier.setTitle(profile.publisherFacebookIdentifier, for: .normal)
        
        self.profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        self.profileImageView.layer.masksToBounds = true
        
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
