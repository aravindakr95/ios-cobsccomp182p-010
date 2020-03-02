//
//  NETextField.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class NETextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }

    private func setupTextField() {
        clipsToBounds = true
    }
}
