//
//  ResetPasswordViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var txtResetPassword: NETextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }
    
    private func configureStyles() {
        self.txtResetPassword.setLeftPaddingPoints(5)
        self.txtResetPassword.setRightPaddingPoints(5)
    }

}
