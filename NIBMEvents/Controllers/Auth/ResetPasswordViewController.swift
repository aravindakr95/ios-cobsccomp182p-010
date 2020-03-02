//
//  ResetPasswordViewController.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var txtEmail: NETextField!
    @IBOutlet weak var btnResetPassword: NEButton!
    @IBOutlet weak var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }

    private func configureStyles() {
        self.imgLogo.layer.cornerRadius = imgLogo.bounds.width / 2.0
        self.imgLogo.layer.masksToBounds = true
        
        self.txtEmail.setLeftPaddingPoints(5)
        self.txtEmail.setRightPaddingPoints(5)
    }

    @IBAction func onResetPassword(_ sender: NEButton) {
        let (valid, error) = FieldValidator.validate(type: "Reset Password", textField: self.txtEmail)

        if !valid {
            let alert = NotificationManager.sharedInstance.showAlert(
                header: "Registration Failed",
                body: "\(error) field is missing or invalid.", action: "Okay")

            self.present(alert, animated: true, completion: nil)
            return
        }
        self.btnResetPassword.showLoading()

        AuthManager.sharedInstance.sendPasswordReset(emailField: txtEmail) {[weak self] (_ success, error) in
            guard let `self` = self else { return }

            var alert: UIViewController

            if (error != nil) {
                alert = NotificationManager.sharedInstance.showAlert(header: "Password Reset Failed", body: error!, action: "Okay")

                self.present(alert, animated: true, completion: nil)
            } else {
                alert = NotificationManager.sharedInstance.showAlert(
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

    @IBAction func unwindToInitial(_ sender: UIBarButtonItem) {
        TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: "unwindToInitial")
    }

    private func transitionToMain() {
        DispatchQueue.main.async {
            TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: "resetPWToSignIn")
        }
    }
}
