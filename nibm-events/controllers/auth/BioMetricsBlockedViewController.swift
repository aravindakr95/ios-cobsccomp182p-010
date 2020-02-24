//
//  BioMetricsBlockedViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class BioMetricsBlockedViewController: UIViewController {
    let authManager: AuthManager = AuthManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func onReAuthenticate(_ sender: NEButton) {
        isAuthorized()
    }
    
    private func isAuthorized() {
        authManager.currentUser {(userData, error) in
            let isAuthorized = UserDefaults.standard.bool(forKey: "isAuthorized")
            if userData != nil && isAuthorized {
                self.canPerformBioMetricsVerification()
            }
        }
    }
    
    private func canPerformBioMetricsVerification() {
        self.authManager.authWithBioMetrics {[weak self] (success, error) in
            guard let `self` = self else { return }
            
            if (error == nil) {
                self.transitionToHome()
            }
        }
    }
    
    private func transitionToHome() {
        DispatchQueue.main.async {
            TransitionManager.pushViewController(storyBoardName: "Home", vcIdentifier: "HomeVC", context: self.navigationController!)
        }
    }
}
