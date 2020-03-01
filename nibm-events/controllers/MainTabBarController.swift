//
//  MainTabBarController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/27/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var tabBarItemOne: UITabBarItem = UITabBarItem()
    var tabBarItemTwo: UITabBarItem = UITabBarItem()
    
    var isGuest: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.isGuest = UserDefaults.standard.bool(forKey: "isGuest")
        if isGuest! {
            let tabBarControllerItems = self.tabBarController?.tabBar.items
            
            if let arrayOfTabBarItems = tabBarControllerItems as! AnyObject as? NSArray {
                tabBarItemOne = arrayOfTabBarItems[1] as! UITabBarItem
                tabBarItemOne.isEnabled = false
                
                tabBarItemTwo = arrayOfTabBarItems[2] as! UITabBarItem
                tabBarItemTwo.isEnabled = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        tabBarItemOne.isEnabled = true
        tabBarItemTwo.isEnabled = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
