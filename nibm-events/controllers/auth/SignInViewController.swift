//
//  SignInViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var txtEmail: NETextField!
    @IBOutlet weak var txtPassword: NETextField!

    @IBOutlet weak var btnSignIn: NEButton!

    var alert: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }

    private func configureStyles() {
        self.txtEmail.setLeftPaddingPoints(5)
        self.txtEmail.setRightPaddingPoints(5)

        self.txtPassword.setLeftPaddingPoints(5)
        self.txtPassword.setRightPaddingPoints(5)
    }

    @IBAction func onResetPassword(_ sender: UIButton) {
        self.transition(identifier: "signInToResetPW")
    }

    @IBAction func onSignIn(_ sender: NEButton) {
        var fields: [String: NETextField] = [:]
        var fieldErrors = [String: String]()

        fields = [ "Email": txtEmail, "Password": txtPassword ]

        for (type, field) in fields {
            let (valid, message) = FieldValidator.validate(type: type, textField: field)
            if (!valid) {
                fieldErrors.updateValue(message, forKey: type)
            }
        }

        if !fieldErrors.isEmpty {
            self.alert = NotificationManager.sharedInstance.showAlert(
                header: "Sign In Failed",
                body: "The following \(fieldErrors.values.joined(separator: ", ")) field(s) are invalid.",
                action: "Okay")

            self.present(self.alert, animated: true, completion: nil)

            return
        }

        self.btnSignIn.showLoading()

        AuthManager.sharedInstance.signIn(emailField: txtEmail.text!, passwordField: txtPassword.text!) {[weak self] (_ success, error) in
            guard let `self` = self else { return }

            if (error != nil) {
                self.alert = NotificationManager.sharedInstance.showAlert(header: "Sign In Failed", body: error!, action: "Okay")
                self.present(self.alert, animated: true, completion: nil)
            } else {
                UserDefaults.standard.set(true, forKey: "isAuthorized")
                self.transition(identifier: "signInToHome")
            }

            self.btnSignIn.hideLoading()
        }
    }
    
    @IBAction func unwindToInitial(_ sender: UIBarButtonItem) {
        TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: "unwindToInitial")
    }

    private func transition(identifier: String) {
        DispatchQueue.main.async {
            TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: identifier)
        }
    }
}
