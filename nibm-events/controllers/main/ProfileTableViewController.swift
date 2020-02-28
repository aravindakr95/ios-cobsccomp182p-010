//
//  ProfileTableViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/25/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        let authManager = AuthManager()
        authManager.signOut { [weak self] (_ success, _ error) in
            guard let `self` = self else { return }
            if (error != nil) {
                print("Something went wrong while signing out.")
            } else {
                let alert = NotificationManager.showAlert(
                    header: "Sign Out",
                    body: "You are about to signing out.", action: "Okay", handler: {(_: UIAlertAction!) in
                        self.transitionToRootView()
                })
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func transitionToRootView() {
        DispatchQueue.main.async {
            TransitionManager.transitionSegue(sender: self, identifier: "profileToAuth")
        }
    }
}
