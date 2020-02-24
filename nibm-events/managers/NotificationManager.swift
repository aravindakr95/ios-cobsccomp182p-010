//
//  NotificationManager.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

final class NotificationManager {
    public static func showAlert(header: String, body: String, action: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIViewController {
        let alert = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: handler))
        
        return alert
    }
}
