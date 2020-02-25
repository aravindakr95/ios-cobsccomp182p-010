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

    public static func pushViewController(storyBoardName: String, vcIdentifier: String, context: UINavigationController) {
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: vcIdentifier)

        context.pushViewController(viewController, animated: true)
    }

    public static func popToViewController(storyBoardName: String, vcIdentifier: String, context: UINavigationController) {
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: vcIdentifier)

        context.popToViewController(viewController, animated: true)
    }

    public static func popToRootViewController(context: UINavigationController) {
        context.popToRootViewController(animated: true)
    }
}
