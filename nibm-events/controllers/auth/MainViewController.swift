//
//  MainViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/21/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import LocalAuthentication
import RxSwift

class MainViewController: UIViewController {
    
    private let localAuthContext: LAContext = LAContext()
    private let authManager: AuthManager = AuthManager()
    private let bioMetric: BehaviorSubject<String> = BehaviorSubject(value: "BioMetric")
    
    var availableBioMetricType: Observable<String> {
        return bioMetric.asObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isAuthorized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onGuest(_ sender: NEButton) {}
    
    @IBAction func onSignUp(_ sender: NEButton) {
        self.transition(identifier: "mainToSignUp")
    }
    
    @IBAction func onSignIn(_ sender: NEButton) {
        self.transition(identifier: "mainToSignIn")
    }
    
    private func isAuthorized() {
        self.authManager.isAuthorized {[weak self] (_ success, error) in
            guard let `self` = self else { return }
            
            if (error == nil) {
                self.canPerformBioMetricsVerification()
            }
        }
    }
    
    private func canPerformBioMetricsVerification() {
        self.authManager.authWithBioMetrics {[weak self] (type, _ success, error) in
            guard let `self` = self else { return }
            
            if (error != nil) {
                let alert = NotificationManager.showAlert(
                    header: "Authentication Failed",
                    body: error!, action: "Okay", handler: {(_: UIAlertAction!) in
                        
                        if (type != "Not Supported") {
                            self.bioMetric.onNext(type!)
                            self.transition(identifier: "mainToBMBlocked")
                        }
                })
                self.present(alert, animated: true, completion: nil)
            } else {
                self.transition(identifier: "mainToMainTab")
            }
        }
    }
    
    private func transition(identifier: String) {
        DispatchQueue.main.async {
            TransitionManager.transitionSegue(sender: self, identifier: identifier)
        }
    }
}
