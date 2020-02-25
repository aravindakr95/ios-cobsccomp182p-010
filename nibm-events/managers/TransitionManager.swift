//
//  TransitionManager.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class TransitionManager {
    public static func transitionSegue(sender: UIViewController, identifier: String) {
        sender.performSegue(withIdentifier: identifier, sender: sender)
    }

    public static func showViewController(storyBoardName: String, vcIdentifier: String, context: UIViewController) {
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: vcIdentifier)

        context.show(viewController, sender: context)
    }
}
