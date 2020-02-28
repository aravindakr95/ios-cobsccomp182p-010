//
//  AddEventViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/28/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    @IBOutlet weak var imgEvent: UIImageView!
    
    @IBOutlet weak var txtEventName: NETextField!
    @IBOutlet weak var txtEventBody: NETextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }
    
    @IBAction func onAddEvent(_ sender: UIBarButtonItem) {}
    

    @IBAction func onCancelEvent(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configureStyles() {
        self.txtEventName.setLeftPaddingPoints(5)
        self.txtEventName.setRightPaddingPoints(5)
        
        self.txtEventBody.setLeftPaddingPoints(5)
        self.txtEventBody.setRightPaddingPoints(5)
        
        self.imgEvent.layer.cornerRadius = imgEvent.bounds.width / 2.0
        self.imgEvent.layer.masksToBounds = true
    }
}
