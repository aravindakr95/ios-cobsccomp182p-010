//
//  NotificationManager.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

final class NotificationManager {
    public static let sharedInstance = NotificationManager()
    
    func showAlert(header: String, body: String,
                   action: String,
                   cancelable: Bool? = false,
                   handler: ((UIAlertAction) -> Void)? = nil) -> UIViewController {
        let alert = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        let mainAction = UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: handler)
        
        if cancelable! {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAction)
        }
        alert.addAction(mainAction)
        
        return alert
    }
}
