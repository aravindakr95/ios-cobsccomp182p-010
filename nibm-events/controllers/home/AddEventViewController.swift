//
//  AddEventViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/28/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import MobileCoreServices
import DateTimePicker
import SVProgressHUD
import FirebaseFirestore

class AddEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var isNewEventImage: Bool?
    var dateTime: Timestamp?
    
    @IBOutlet weak var imgEvent: UIImageView!
    
    @IBOutlet weak var txtEventName: NETextField!
    @IBOutlet weak var txtEventBody: NETextField!
    
    @IBOutlet weak var btnDateTime: NEButton!
    @IBOutlet weak var btnEventLocation: NEButton!
    
    @IBAction func onAddDateTime(_ sender: NEButton) {
        let picker = DateTimePicker.show()
        picker.is12HourFormat = true
        picker.timeZone = TimeZone.current
        picker.completionHandler = { date in
            self.dateTime = Timestamp(date: Date())
            let omitTimezone = date.description.components(separatedBy: "+")
            self.btnDateTime.setTitle(omitTimezone[0], for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
    }
    
    @IBAction func onAddEvent(_ sender: UIBarButtonItem) {
        var fields: [String: NETextField] = [:]
        var fieldErrors = [String: String]()
        
        fields = [ "Event Title": txtEventName, "Description": txtEventBody ]
        
        for (type, field) in fields {
            let (valid, message) = FieldValidator.validate(type: type, textField: field)
            if (!valid) {
                fieldErrors.updateValue(message, forKey: type)
            }
        }
        
        if !fieldErrors.isEmpty {
            let alert = NotificationManager.sharedInstance.showAlert(
                header: "Add Event Failed",
                body: "The following \(fieldErrors.values.joined(separator: ", ")) field(s) are invalid.",
                action: "Okay")
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
    }
    
    @IBAction func onCancelEvent(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddLocation(_ sender: NEButton) {
        self.btnEventLocation.setTitle("Colombo", for: .normal) // As per LocationPicker gives me a error (cannot comple objective c library)
    }
    
    @IBAction func onAddEventPhoto(_ sender: UIButton) {
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
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.imgEvent.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func invokeServices() {
        SVProgressHUD.show(withStatus: "Please wait")
        guard let user = AuthManager.sharedInstance.user,
            let profile = UserProfile(user: UserDefaults.standard.value(forKey: "userProfile") as! [String : Any])
            else { return }
        DatabaseManager.sharedInstance.uploadImage(image: self.imgEvent.image!,
                                                   email: user.email!,
                                                   type: .event) { (url, error) in
                                                    if url != nil {
                                                        let data: [String: Any] = [
                                                            "uid": user.uid,
                                                            "publisher": profile.firstName + profile.lastName,
                                                            "publisherBatch": profile.batch.uppercased(),
                                                            "publisherContactNumber": profile.contactNumber,
                                                            "publisherFacebookIdentifier": profile.facebookIdentifier,
                                                            "publisherImageUrl": profile.profileImageUrl,
                                                            "publishedLocation": "Colombo", // As per Location picker gives me a error hardcoded it (cannot comple objective c library)
                                                            "timeStamp": self.dateTime,
                                                            "title": self.txtEventName.text!,
                                                            "body": self.txtEventBody.text!,
                                                            "isGoing": false,
                                                            "eventImageUrl": url!
                                                        ]
                                                        
                                                        DatabaseManager.sharedInstance.insertDocument(collection: "events", data: data) { (success, error) in
                                                            if error == nil {
                                                                SVProgressHUD.dismiss()
                                                                let alert = NotificationManager.sharedInstance.showAlert(
                                                                    header: "Add Event Success",
                                                                    body: "Event is recoreded successfully.",
                                                                    action: "Okay",
                                                                    handler: {(_: UIAlertAction!) in
                                                                        self.dismiss(animated: true, completion: nil)
                                                                })
                                                                
                                                                self.present(alert, animated: true, completion: nil)
                                                            } else { print("not insert document")}
                                                        }
                                                    } else {
                                                        print ("not upload")
                                                        
                                                    }
        }
    }
    
    private func configureStyles() {
        self.txtEventName.setLeftPaddingPoints(5)
        self.txtEventName.setRightPaddingPoints(5)
        
        self.txtEventBody.setLeftPaddingPoints(5)
        self.txtEventBody.setRightPaddingPoints(5)
    }
}
