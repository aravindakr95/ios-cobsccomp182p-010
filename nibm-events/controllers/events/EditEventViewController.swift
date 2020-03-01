//
//  EditEventViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 3/1/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import DateTimePicker
import MobileCoreServices
import Kingfisher

class EditEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imgEventView: UIImageView!
    
    @IBOutlet weak var btnEventLocation: NEButton!
    @IBOutlet weak var btnDateTime: NEButton!
    
    @IBOutlet weak var txtEventTitle: NETextField!
    @IBOutlet weak var txtEventDescription: NETextField!
    
    var isNewEventImage: Bool = false
    
    var event: Event! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBAction func onChangeLocation(_ sender: NEButton) {}
    
    @IBAction func onChangeDateTime(_ sender: NEButton) {
        let picker = DateTimePicker.show()
        picker.is12HourFormat = true
        picker.timeZone = TimeZone.current
        picker.completionHandler = { date in
            let omitTimezone = date.description.components(separatedBy: "+")
            self.btnDateTime.setTitle(omitTimezone[0], for: .normal)
        }
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEditEventPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Event Image From", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.isNewEventImage = true
            }
        }
        
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.isNewEventImage = false
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(cameraAction)
        alert.addAction(cameraRollAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func updateUI() {
        guard let event = event else { return }
        
        let imgUrl = URL(string: event.eventImageUrl)
        self.imgEventView.kf.indicatorType = .activity
        self.imgEventView.kf.setImage(with: imgUrl)
        
        let omitTimeZone = event.timeStamp.description.components(separatedBy: "+")
        self.btnEventLocation.setTitle(event.publishedLocation, for: .normal)
        self.btnDateTime.setTitle(omitTimeZone[0], for: .normal)
        self.txtEventTitle.text = event.title
        self.txtEventDescription.text = event.body
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.imgEventView.image = image
            
            if isNewEventImage == true {
                guard let userProfile = AuthManager.sharedInstance.userProfile,
                    let email = userProfile.email else { return }
                
                DatabaseManager.sharedInstance.uploadImage(image: image, email: email, type: .event) { (success, error) in
                    if (error == nil) {
                        print(success)
                    } else {
                        print(error)
                    }
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
