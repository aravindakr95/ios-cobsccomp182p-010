//
//  PublisherProfileViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/29/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class PublisherProfileViewController: UIViewController {
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblBatch: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    
    @IBOutlet weak var btnFacebookIdentifier: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var profile: Event! {
        didSet {
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateUI() {
//        guard let profile = profile else { return }
//        guard let documentId = profile.documentId else { return }
        
//        if (!documentId.isEmpty) {
//            self.lblFullName.text = profile.publisher
//            self.lblBatch.text = profile.publisherBatch
//            //        self.lblContactNumber.text = profile.publisherContactNumber
//            self.btnFacebookIdentifier.setTitle(profile.publisherFacebookIdentifier, for: .normal)
//
//            self.profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
//            self.profileImageView.layer.masksToBounds = true
//        }
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
