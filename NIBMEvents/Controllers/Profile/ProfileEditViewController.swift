//
//  ProfileEditViewController.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/28/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var txtFirstName: NETextField!
    @IBOutlet weak var txtLastName: NETextField!
    @IBOutlet weak var txtPassword: NETextField!
    @IBOutlet weak var txtConfirmPassword: NETextField!
    @IBOutlet weak var txtContactNumber: NETextField!
    @IBOutlet weak var txtFacebookIdentifier: NETextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }

    @IBAction func onComplete(_ sender: UIBarButtonItem) {}

    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    private func configureStyles() {
        self.txtFirstName.setLeftPaddingPoints(5)
        self.txtFirstName.setRightPaddingPoints(5)

        self.txtLastName.setLeftPaddingPoints(5)
        self.txtLastName.setRightPaddingPoints(5)

        self.txtPassword.setLeftPaddingPoints(5)
        self.txtPassword.setRightPaddingPoints(5)

        self.txtConfirmPassword.setLeftPaddingPoints(5)
        self.txtConfirmPassword.setRightPaddingPoints(5)

        self.txtContactNumber.setLeftPaddingPoints(5)
        self.txtContactNumber.setRightPaddingPoints(5)

        self.txtFacebookIdentifier.setLeftPaddingPoints(5)
        self.txtFacebookIdentifier.setRightPaddingPoints(5)

        self.profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        self.profileImageView.layer.masksToBounds = true
    }
}
