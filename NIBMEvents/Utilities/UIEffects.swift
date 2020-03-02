//
//  UIEffects.swift
//  NIBMEvents
//
//  Created by Aravinda Rathnayake on 2/29/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class UIEffects {
    static func blur(context: UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.frame = context.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        context.addSubview(blurEffectView)
    }

    static func removeBlur(context: UIView) {
        for subview in context.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
}
