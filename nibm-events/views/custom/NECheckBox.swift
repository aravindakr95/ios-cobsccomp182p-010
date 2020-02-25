//
//  NECheckBox.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class NECheckBox: UIButton {
    let selectedCheckBox = UIImage(named: "checkbox-selected")
    let unselectedCheckBox = UIImage(named: "checkbox-deselected")

    var isChecked: Bool = false {
        didSet {
            self.setImage(
                self.isChecked ?  self.selectedCheckBox : self.unselectedCheckBox,
                for: UIControl.State.normal
            )
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
