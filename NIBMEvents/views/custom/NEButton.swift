//
//  NEButton.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/23/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class NEButton: UIButton {
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        clipsToBounds = true
        layer.cornerRadius  = CGFloat(5)
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white

        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(activityIndicator)

        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerX,
            multiplier: 1,
            constant: 0)
        let yCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerY,
            multiplier: 1,
            constant: 0)

        self.addConstraint(xCenterConstraint)
        self.addConstraint(yCenterConstraint)
    }

    public func showLoading() {
        self.originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)

        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        self.showSpinning()
    }

    public func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }
}
