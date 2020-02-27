//
//  ResetPasswordViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail: NETextField!
    @IBOutlet weak var btnResetPassword: NEButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }

    private func configureStyles() {
        self.txtEmail.setLeftPaddingPoints(5)
        self.txtEmail.setRightPaddingPoints(5)
    }

    @IBAction func onResetPassword(_ sender: NEButton) {
        let authManager: AuthManager = AuthManager()

        self.btnResetPassword.showLoading()

        authManager.sendPasswordReset(emailField: txtEmail) {[weak self] (_ success, error) in
            guard let `self` = self else { return }

            var alert: UIViewController

            if (error != nil) {
                alert = NotificationManager.showAlert(header: "Password Reset Failed", body: error!, action: "Okay")

                self.present(alert, animated: true, completion: nil)
            } else {
                alert = NotificationManager.showAlert(
                    header: "Email Sent",
                    body: "We have sent a password reset instructions to your \(self.txtEmail.text!) email address.",
                    action: "Okay", handler: {(_: UIAlertAction!) in

                    self.transitionToMain()
                })

                self.present(alert, animated: true, completion: nil)
            }
            self.btnResetPassword.hideLoading()
        }
    }

    private func transitionToMain() {
        DispatchQueue.main.async {
            TransitionManager.pushViewController(storyBoardName: "Auth", vcIdentifier: "MainVC", context: self)
        }
    }

}
