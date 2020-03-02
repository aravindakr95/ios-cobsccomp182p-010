//
//  MainTabBarController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/27/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    private var tabBarItemOne: UITabBarItem = UITabBarItem()
    private var tabBarItemTwo: UITabBarItem = UITabBarItem()
    private var isGuest: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableGuestFunctions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        tabBarItemOne.isEnabled = true
        tabBarItemTwo.isEnabled = true
    }
    
    private func enableGuestFunctions() {
        self.isGuest = UserDefaults.standard.bool(forKey: "isGuest")
        if isGuest! {
            self.tabBar.isHidden  = true
        }
    }
}
