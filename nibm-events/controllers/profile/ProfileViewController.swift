//
//  ProfileViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/25/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblFacebookIdentifier: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }
    
    @IBAction func onSignout(_ sender: NEButton) {
        AuthManager.sharedInstance.signOut { [weak self] (_ success, _ error) in
            guard let `self` = self else { return }
            if (error != nil) {
                print("Something went wrong while signing out.")
            } else {
                let alert = NotificationManager.sharedInstance.showAlert(
                    header: "Sign Out",
                    body: "You are about to signing out.", action: "Okay", handler: {(_: UIAlertAction!) in
                        self.transition(identifier: "profileToAuth")
                })
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onEditProfile(_ sender: UIBarButtonItem) {
        self.transition(identifier: "profileToEditProfile")
    }
    
    private func configureStyles() {
        self.profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        self.profileImageView.layer.masksToBounds = true
    }
    
    private func transition(identifier: String) {
        DispatchQueue.main.async {
            TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: identifier)
        }
    }
}
