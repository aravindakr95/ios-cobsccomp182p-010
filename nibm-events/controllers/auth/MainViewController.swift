//
//  MainViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/21/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import LocalAuthentication

class MainViewController: UIViewController {
    let localAuthContext: LAContext = LAContext()
    let authManager: AuthManager = AuthManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.isAuthorized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func isAuthorized() {
        AuthManager().currentUser {(userData, error) in
            let isAuthorized = UserDefaults.standard.bool(forKey: "isAuthorized")
            if userData != nil && isAuthorized {
                self.canPerformBioMetricsVerification()
            }
        }
    }
    
    private func canPerformBioMetricsVerification() {
        self.authManager.authWithBioMetrics {[weak self] (success, error) in
            guard let `self` = self else { return }
            
            if (error != nil) {
                let alert = NotificationManager.showAlert(header: "Authentication Failed", body: error!, action: "Okay")
                self.present(alert, animated: true, completion: nil)
                
                self.transition(sbName: "Auth", identifier: "BioMetricsBlockedVC")
            } else {
                self.transition(sbName: "Home", identifier: "HomeVC")
            }
        }
    }
    
    private func transition(sbName: String, identifier: String) {
        DispatchQueue.main.async {
            TransitionManager.pushViewController(storyBoardName: sbName, vcIdentifier: identifier, context: self.navigationController!)
        }
    }
}

