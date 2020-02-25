//
//  SignUpViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var txtFirstName: NETextField!
    @IBOutlet weak var txtLastName: NETextField!
    @IBOutlet weak var txtEmail: NETextField!
    @IBOutlet weak var txtPassword: NETextField!
    @IBOutlet weak var txtConfirmPassword: NETextField!
    @IBOutlet weak var txtContactNumber: NETextField!
    @IBOutlet weak var txtFacebookIdentifier: NETextField!

    @IBOutlet weak var btnSignUp: NEButton!

    @IBOutlet weak var cbAgreement: NECheckBox!

    var alert: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }

    private func configureStyles() {
        self.txtFirstName.setLeftPaddingPoints(5)
        self.txtFirstName.setRightPaddingPoints(5)

        self.txtLastName.setLeftPaddingPoints(5)
        self.txtLastName.setRightPaddingPoints(5)

        self.txtEmail.setLeftPaddingPoints(5)
        self.txtEmail.setRightPaddingPoints(5)

        self.txtPassword.setLeftPaddingPoints(5)
        self.txtPassword.setRightPaddingPoints(5)

        self.txtConfirmPassword.setLeftPaddingPoints(5)
        self.txtConfirmPassword.setRightPaddingPoints(5)

        self.txtContactNumber.setLeftPaddingPoints(5)
        self.txtContactNumber.setRightPaddingPoints(5)

        self.txtFacebookIdentifier.setLeftPaddingPoints(5)
        self.txtFacebookIdentifier.setRightPaddingPoints(5)
    }

    @IBAction func onSignUp(_ sender: NEButton) {
        var fields: [String: NETextField] = [:]
        var fieldErrors = [String: String]()

        // TODO: Refer usage comment
        let isChecked = !cbAgreement.isChecked
        let authManager: AuthManager = AuthManager()
        let fieldValidator = FieldValidator()

        fields = [
            "First Name": txtFirstName,
            "Last Name": txtLastName,
            "Email": txtEmail,
            "Password": txtPassword,
            "Contact Number": txtContactNumber,
            "Facebook Identifier": txtFacebookIdentifier
        ]

        for (type, field) in fields {
            if type == "Password" {
                let (valid, message) = fieldValidator.validate(type: type, textField: field, optionalField: txtConfirmPassword)
                if (!valid ) {
                    fieldErrors.updateValue(message, forKey: type)
                }
            } else {
                let (valid, message) = fieldValidator.validate(type: type, textField: field)
                if (!valid) {
                    fieldErrors.updateValue(message, forKey: type)
                }
            }
        }

        if !fieldErrors.isEmpty {
            alert = NotificationManager.showAlert(
                header: "Registration Failed",
                body: "The following \(fieldErrors.values.joined(separator: ", ")) field(s) are missing or invalid.", action: "Okay")

            self.present(alert, animated: true, completion: nil)

            return
        }

        // FIXME: cbAgreement isChecked method returns wrong state of the checkbox
        if isChecked {
            alert = NotificationManager.showAlert(
                header: "Registration Failed",
                body: "Please read our Privacy Policy and agree to the Terms and Conditions.", action: "Okay")

            self.present(alert, animated: true, completion: nil)

            return
        }

        btnSignUp.showLoading()

        authManager.createUser(emailField: txtEmail, passwordField: txtPassword) {[weak self] (userData, error) in
            guard let `self` = self else { return }

            if (error != nil) {
                self.alert = NotificationManager.showAlert(header: "Registration Failed", body: error!, action: "Okay")

                self.present(self.alert, animated: true, completion: nil)
            } else {
                let databaseManager: DatabaseManager = DatabaseManager()

                let data: [String: String] = [
                    "uid": userData!.uid,
                    "firstName": self.txtFirstName.text!,
                    "lastName": self.txtLastName.text!,
                    "indexNumber": self.txtContactNumber.text!
                ]

                databaseManager.insert(collection: "users", data: data) {[weak self] (_ success, error) in
                    guard let `self` = self else { return }

                    if (error != nil) {
                        self.alert = NotificationManager.showAlert(header: "Registration Failed", body: error!, action: "Okay")
                        self.present(self.alert, animated: true, completion: nil)

                        return
                    } else {
                        self.alert = NotificationManager.showAlert(
                            header: "Registration Success",
                            body: "Registration is Successful, Please Sign In.", action: "Okay", handler: {(_: UIAlertAction!) in
                            self.transitionToSignIn()
                        })
                        self.present(self.alert, animated: true, completion: nil)
                    }
                }
            }
            self.btnSignUp.hideLoading()
        }
    }

    private func transitionToSignIn() {
        DispatchQueue.main.async {
            TransitionManager.pushViewController(storyBoardName: "Auth", vcIdentifier: "SignInVC", context: self.navigationController!)
        }
    }
}
