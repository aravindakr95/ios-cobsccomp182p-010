//
//  HomeViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func onLogout(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isAuthorized")
        self.transitionToMain()
    }

    private func transitionToMain() {
        DispatchQueue.main.async {
            TransitionManager.showViewController(storyBoardName: "Auth", vcIdentifier: "MainVC", context: self)
        }
    }
}
