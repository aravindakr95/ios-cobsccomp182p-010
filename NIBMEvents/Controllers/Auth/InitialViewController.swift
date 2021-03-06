//
//  InitialViewController.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/21/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import LocalAuthentication

class InitialViewController: UIViewController {
    @IBOutlet weak var imgMain: UIImageView!
    
    private let localAuthContext: LAContext = LAContext()
    private var bioMetricType = "Not Supported"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isAuthorized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "initialToAuthBMBlocked") {
            if let viewController = segue.destination as? AuthBioMetricsBlockedViewController {
                viewController.bioMetricType = self.bioMetricType
            }
        }
    }
    
    @IBAction func unwind(segue:UIStoryboardSegue) { }
    
    @IBAction func onGuest(_ sender: NEButton) {
        UserDefaults.standard.set(true, forKey: "isGuest")
        self.transition(identifier: "initialToHome")
    }
    
    @IBAction func onSignUp(_ sender: NEButton) {
        self.transition(identifier: "initialToSignUp")
    }
    
    @IBAction func onSignIn(_ sender: NEButton) {
        self.transition(identifier: "initialToSignIn")
    }
    
    private func configureStyles() {
        self.imgMain.layer.cornerRadius = imgMain.bounds.width / 2.0
        self.imgMain.layer.masksToBounds = true
    }
    
    private func isAuthorized() {
        AuthManager.sharedInstance.isAuthorized {[weak self] (_ success, error) in
            guard let `self` = self else { return }
            
            if success! {
                UserDefaults.standard.set(false, forKey: "isGuest")
                self.canPerformBioMetricsVerification()
                self.setUserProfile()
            }
        }
    }
    
    private func setUserProfile() {
        AuthManager.sharedInstance.getUserProfile(uid: AuthManager.sharedInstance.user.uid) { success, error in
            if error == nil {
                print("User profile added to the instance.")
            } else {
                print("Failed to add user profile into instance.")
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
                    body: error!, action: "Okay", handler: {(_: UIAlertAction!) in
                        if (type != "Not Supported") {
                            self.bioMetricType = type!
                            self.transition(identifier: "initialToAuthBMBlocked")
                        }
                })
                self.present(alert, animated: true, completion: nil)
            } else {
                self.transition(identifier: "initialToHome")
            }
            self.unBlurBackground()
        }
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
