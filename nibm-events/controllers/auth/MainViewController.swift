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

    var bioMetricsType: String = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.isAuthorized()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onGuest(_ sender: NEButton) {}

    @IBAction func onSignUp(_ sender: NEButton) {
        self.transition(sbName: "Auth", identifier: "SignUpVC")
    }

    @IBAction func onSignIn(_ sender: NEButton) {
        self.transition(sbName: "Auth", identifier: "SignInVC")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MainToBMBlockedSegue") {
            let viewController = segue.destination as? BioMetricsBlockedViewController
            viewController!.bioMetricsType = self.bioMetricsType
        }
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
                    self.bioMetricsType = type!

                    if (self.bioMetricsType != "Not Supported") {
                        TransitionManager.transitionSegue(sender: self, identifier: "MainToBMBlockedSegue")
                    }
                })
                self.present(alert, animated: true, completion: nil)
            } else {
                self.transition(sbName: "Home", identifier: "HomeVC")
            }
        }
    }

    private func transition(sbName: String, identifier: String) {
        DispatchQueue.main.async {
            TransitionManager.showViewController(storyBoardName: sbName, vcIdentifier: identifier, context: self)
        }
    }
}
