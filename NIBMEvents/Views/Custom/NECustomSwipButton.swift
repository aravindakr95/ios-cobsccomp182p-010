//
//  NECustomSwipButton.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

@IBDesignable class NECustomSwipButton: UIButton {
    var selectedImage: UIImage!
    var deSelectedImage: UIImage!

    @IBInspectable var selectImage: String = "checkbox-selected" {
        didSet {
            self.selectedImage = UIImage(named: selectImage)
        }
    }
    
    @IBInspectable var deSelectImage: String = "checkbox-deselected" {
        didSet {
            self.deSelectedImage = UIImage(named: deSelectImage)
        }
    }

    var isChecked: Bool = false {
        didSet {
            self.setImage(
                self.isChecked ?  self.selectedImage : self.deSelectedImage,
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
