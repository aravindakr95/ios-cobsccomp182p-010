//
//  TransitionManager.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class TransitionManager {
    public static let sharedInstance = TransitionManager()

    func transitionSegue(sender: UIViewController, identifier: String) {
        sender.performSegue(withIdentifier: identifier, sender: sender)
    }
}
