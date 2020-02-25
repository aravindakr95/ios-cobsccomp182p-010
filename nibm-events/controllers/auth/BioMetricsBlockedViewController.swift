//
//  BioMetricsBlockedViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class BioMetricsBlockedViewController: UIViewController {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnBioMetric: UIButton!

    let authManager: AuthManager = AuthManager()
    var bioMetricsType: String = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.lblDescription.text = "Unlock with \(self.bioMetricsType) to open NIBM Events"
        self.btnBioMetric.setTitle("Use \(self.bioMetricsType)", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func onReAuthenticate(_ sender: NEButton) {
        isAuthorized()
    }

    private func isAuthorized() {
        self.authManager.isAuthorized {[weak self] (_ success, error) in
            guard let `self` = self else { return }

            if (error == nil) {
                self.canPerformBioMetricsVerification()
            }
        }
    }

    private func canPerformBioMetricsVerification() {
        self.authManager.authWithBioMetrics {[weak self] (_ bioMetricType, _ success, error) in
            guard let `self` = self else { return }

            if (error == nil) {
                self.transitionToHome()
            }
        }
    }

    private func transitionToHome() {
        DispatchQueue.main.async {
            TransitionManager.showViewController(storyBoardName: "Home", vcIdentifier: "HomeVC", context: self)
        }
    }
}
