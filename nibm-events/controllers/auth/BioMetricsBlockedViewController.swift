//
//  BioMetricsBlockedViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import RxSwift

class BioMetricsBlockedViewController: UIViewController {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnBioMetric: UIButton!

    private let authManager: AuthManager = AuthManager()
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBioMetricsLables()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onReAuthenticate(_ sender: UIButton) {
        isAuthorized()
    }

    private func setBioMetricsLables() {
        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainViewController

        mainVC?.availableBioMetricType.subscribe(onNext: { [weak self] type in
            guard let `self` = self else { return }

            self.lblDescription.text = "Unlock with \(type) to open NIBM Events"
            self.btnBioMetric.setTitle("Use \(type)", for: .normal)
        }).disposed(by: disposeBag)
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
            TransitionManager.pushViewController(storyBoardName: "Home", vcIdentifier: "HomeTabVC", context: self)
        }
    }
}
