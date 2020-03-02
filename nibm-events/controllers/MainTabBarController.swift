//
//  MainTabBarController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/27/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    private var isGuest: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.enableGuestFunctions()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func enableGuestFunctions() {
        self.isGuest = UserDefaults.standard.bool(forKey: "isGuest")
        if isGuest! {
            self.tabBar.isHidden  = true
        }
    }
}
