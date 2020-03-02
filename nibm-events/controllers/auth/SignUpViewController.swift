//
//  SignUpViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import MobileCoreServices

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var txtFirstName: NETextField!
    @IBOutlet weak var txtLastName: NETextField!
    @IBOutlet weak var txtEmail: NETextField!
    @IBOutlet weak var txtPassword: NETextField!
    @IBOutlet weak var txtConfirmPassword: NETextField!
    @IBOutlet weak var txtContactNumber: NETextField!
    @IBOutlet weak var txtBatch: NETextField!
    @IBOutlet weak var txtFacebookIdentifier: NETextField!

    @IBOutlet weak var btnSignUp: NEButton!

    @IBOutlet weak var cbAgreement: NECustomSwipButton!

    @IBOutlet weak var imgUser: UIImageView!

    var alert: UIViewController!

    var isNewEventImage: Bool = false
    var isImageSelected: Bool = false

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

        self.txtBatch.setLeftPaddingPoints(5)
        self.txtBatch.setRightPaddingPoints(5)

        self.txtFacebookIdentifier.setLeftPaddingPoints(5)
        self.txtFacebookIdentifier.setRightPaddingPoints(5)
    }

    @IBAction func onAddPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Event Image From", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.isNewEventImage = true
            }
        }

        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.isNewEventImage = false
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")

        alert.addAction(cameraAction)
        alert.addAction(cameraRollAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

    @IBAction func onSignUp(_ sender: NEButton) {
        var fields: [String: NETextField] = [:]
        var fieldErrors = [String: String]()

        // TODO: Refer usage comment
        let isChecked = !cbAgreement.isChecked

        fields = [
            "First Name": txtFirstName,
            "Last Name": txtLastName,
            "Email": txtEmail,
            "Password": txtPassword,
            "Contact Number": txtContactNumber,
            "Batch": txtBatch,
            "Facebook Identifier": txtFacebookIdentifier
        ]

        for (type, field) in fields {
            if type == "Password" {
                let (valid, message) = FieldValidator.validate(type: type, textField: field, optionalField: txtConfirmPassword)
                if (!valid ) {
                    fieldErrors.updateValue(message, forKey: type)
                }
            } else {
                let (valid, message) = FieldValidator.validate(type: type, textField: field)
                if (!valid) {
                    fieldErrors.updateValue(message, forKey: type)
                }
            }
        }

        if !fieldErrors.isEmpty {
            alert = NotificationManager.sharedInstance.showAlert(
                header: "Registration Failed",
                body: "The following \(fieldErrors.values.joined(separator: ", ")) field(s) are missing or invalid.", action: "Okay")

            self.present(alert, animated: true, completion: nil)
            return
        }

        if !isImageSelected {
            alert = NotificationManager.sharedInstance.showAlert(
                header: "Registration Failed",
                body: "The following image field is missing or invalid.", action: "Okay")

            self.present(alert, animated: true, completion: nil)
            return
        }

        // FIXME: cbAgreement isChecked method returns wrong state of the checkbox
        if isChecked {
            alert = NotificationManager.sharedInstance.showAlert(
                header: "Registration Failed",
                body: "Please read our privacy policy and agree to the terms and conditions.", action: "Okay")

            self.present(alert, animated: true, completion: nil)
            return
        }
        self.btnSignUp.showLoading()

        AuthManager.sharedInstance.createUser(emailField: txtEmail, passwordField: txtPassword) {[weak self] (userData, error) in
            guard let `self` = self else { return }

            if error == nil {
                print("user created")
                DatabaseManager.sharedInstance.uploadImage(image: self.imgUser.image!,
                                                           email: self.txtEmail.text!,
                                                           type: .profile) { (url, error) in
                    if error == nil {
                        print("image created")
                        let data: [String: String] = [
                            "uid": userData!.uid,
                            "firstName": self.txtFirstName.text!,
                            "lastName": self.txtLastName.text!,
                            "contactNumber": self.txtContactNumber.text!,
                            "batch": self.txtBatch.text!.uppercased(),
                            "facebookIdentifier": self.txtFacebookIdentifier.text!,
                            "profileImageUrl": url!
                        ]

                        DatabaseManager.sharedInstance.insertDocument(collection: "users", data: data) {[weak self] (_ success, error) in
                            guard let `self` = self else { return }

                            if (error != nil) {
                                print("data not insered")
                                UserDefaults.standard.set(false, forKey: "isAuthorized")
                                self.alert = NotificationManager.sharedInstance.showAlert(header: "Registration Failed", body: error!, action: "Okay")
                                self.present(self.alert, animated: true, completion: nil)
                                return
                            } else {
                                print("data inserted and complete")
                                UserDefaults.standard.set(data, forKey: "userProfile")
                                UserDefaults.standard.set(false, forKey: "isAuthorized")
                                self.btnSignUp.hideLoading()
                                self.alert = NotificationManager.sharedInstance.showAlert(
                                    header: "Registration Success",
                                    body: "Registration is Successful, Please Sign In.", action: "Okay", handler: {(_: UIAlertAction!) in
                                        self.transitionToSignIn()
                                })
                                self.present(self.alert, animated: true, completion: nil)
                            }
                        }
                    } else {
                        UserDefaults.standard.set(false, forKey: "isAuthorized")
                        print("image not created")
                    }
                }
            } else {
                UserDefaults.standard.set(false, forKey: "isAuthorized")
                print("failed to create a user.")
                self.btnSignUp.hideLoading()
            }
        }
    }

    @IBAction func onSignIn(_ sender: NEButton) {
        self.transitionToSignIn()
    }

    @IBAction func unwindToInitial(_ sender: UIBarButtonItem) {
        TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: "unwindToInitial")
    }

    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.imgUser.image = image
            self.isImageSelected = true
        }
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    private func transitionToSignIn() {
        DispatchQueue.main.async {
            TransitionManager.sharedInstance.transitionSegue(sender: self, identifier: "signUpToSignIn")
        }
    }
}
