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
        self.isAuthorized()
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
                    body: "Are you sure you want to sign out?",
                    action: "Yes",
                    cancelable: true,
                    handler: {(_: UIAlertAction!) in
                        self.transition(identifier: "profileToAuth")
                })
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onEditProfile(_ sender: UIBarButtonItem) {
        self.transition(identifier: "profileToEditProfile")
    }
    
    
    private func isAuthorized() {
        AuthManager.sharedInstance.isAuthorized {[weak self] (_ success, error) in
            guard let `self` = self else { return }
            
            if (error == nil) {
                self.canPerformBioMetricsVerification()
            }
        }
    }
    
    private func canPerformBioMetricsVerification() {
        self.blurBackground()
        AuthManager.sharedInstance.authWithBioMetrics {[weak self] (type, _ success, error) in
            guard let `self` = self else { return }
            
            if (error != nil) {
                let alert = NotificationManager.sharedInstance.showAlert(
                    header: "Authentication Failed",
                    body: error!, action: "Okay")
                
                if (type != "Not Supported") {
                    self.isAuthorized()
                }
            }
            self.unBlurBackground()
        }
    }
    
    private func configureStyles() {
        self.profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        self.profileImageView.layer.masksToBounds = true
    }
    
    private func blurBackground() {
        DispatchQueue.main.async {
            UIEffects.blur(context: self.view)
        }
    }
    
    private func unBlurBackground() {
        DispatchQueue.main.async {
            UIEffects.removeBlur(context: self.view)
        }
    }
    
    private func transition(identifier: String) {
        DispatchQueue.main.async {
            TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: identifier)
        }
    }
}
