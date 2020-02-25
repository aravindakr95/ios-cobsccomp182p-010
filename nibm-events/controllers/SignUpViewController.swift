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
    @IBOutlet weak var txtNICNumber: NETextField!

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

        self.txtNICNumber.setLeftPaddingPoints(5)
        self.txtNICNumber.setRightPaddingPoints(5)
    }
}
