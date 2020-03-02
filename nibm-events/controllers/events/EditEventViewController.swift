//
//  EditEventViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 3/1/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import MobileCoreServices

import DateTimePicker
import Kingfisher
import FirebaseFirestore
import SVProgressHUD

class EditEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imgEventView: UIImageView!

    @IBOutlet weak var btnEventLocation: NEButton!
    @IBOutlet weak var btnDateTime: NEButton!
    
    @IBOutlet weak var txtEventTitle: NETextField!
    @IBOutlet weak var txtEventDescription: NETextField!
    @IBOutlet weak var txtContactNumber: NETextField!
    
    var isNewEventImage: Bool = false
    var isImageSelected: Bool = true

    private var dateTime: Timestamp?
    private var event: CustomEvent?

    override func viewDidLoad() {
        self.updateUI()
    }

    @IBAction func onChangeLocation(_ sender: NEButton) {
        self.btnEventLocation.setTitle("Colombo", for: .normal) // As per LocationPicker gives me a error (cannot comple objective c library)
    }

    @IBAction func onChangeDateTime(_ sender: NEButton) {
        let picker = DateTimePicker.show()
        picker.is12HourFormat = true
        picker.timeZone = TimeZone.current
        picker.completionHandler = { date in
            self.dateTime = Timestamp(date: Date())
            let omitTimezone = date.description.components(separatedBy: "+")
            self.btnDateTime.setTitle(omitTimezone[0], for: .normal)
        }
    }

    @IBAction func onEditEvent(_ sender: UIBarButtonItem) {
        var fields: [String: NETextField] = [:]
        var fieldErrors = [String: String]()
        
        fields = [ "Event Title": self.txtEventTitle, "Description": self.txtEventDescription ]
        
        for (type, field) in fields {
            let (valid, message) = FieldValidator.validate(type: type, textField: field)
            if (!valid) {
                fieldErrors.updateValue(message, forKey: type)
            }
        }
        
        if !fieldErrors.isEmpty {
            let alert = NotificationManager.sharedInstance.showAlert(
                header: "Edit Event Failed",
                body: "The following \(fieldErrors.values.joined(separator: ", ")) field(s) are invalid.",
                action: "Okay")
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !self.isImageSelected {
            let alert = NotificationManager.sharedInstance.showAlert(
                header: "Edit Image Failed",
                body: "The following image field is missing or invalid.", action: "Okay")
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.invokeServices()
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

        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default) { _ in
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
        self.event = CustomEvent(event: (UserDefaults.standard.value(forKey: "eventData") as! [String : String]?)!)
        guard let event = event else { return }
        let omitTimezone = Date().description.components(separatedBy: "+")

        let imgUrl = URL(string: event.eventImageUrl!)
        self.imgEventView.kf.indicatorType = .activity
        self.imgEventView.kf.setImage(with: imgUrl)

        self.btnEventLocation.setTitle(event.publishedLocation, for: .normal)
        self.btnDateTime.setTitle(omitTimezone[0], for: .normal)
        self.txtEventTitle.text = event.title
        self.txtEventDescription.text = event.body
        self.txtContactNumber.text = event.publisherContactNumber
    }
    
    private func invokeServices() {
        SVProgressHUD.show(withStatus: "Please wait")
        guard let user = AuthManager.sharedInstance.user,
            let profile = UserProfile(user: UserDefaults.standard.value(forKey: "userProfile") as! [String : Any])
            else { return }

        DatabaseManager.sharedInstance.uploadImage(image: self.imgEventView.image!, email: user.email!, type: .event) { (url, error) in
            if url != nil {
                guard let event = self.event else { return }
                let data: [String: Any] = [
                    "documentId": event.documentId!,
                    "publishedLocation": event.publishedLocation!,
                    "publisherContactNumber": event.publisherContactNumber!,
                    "timeStamp": self.dateTime,
                    "title": event.title,
                    "body": event.body,
                    "eventImageUrl": event.eventImageUrl
                ]
                
                DatabaseManager.sharedInstance.mergeDocument(collection: "events",documentId: event.documentId!, data: data) { (success, _) in
                    if error == nil {
                        SVProgressHUD.dismiss()
                        let alert = NotificationManager.sharedInstance.showAlert(
                            header: "Edit Event Success",
                            body: "Event is updated successfully.",
                            action: "Okay",
                            handler: {(_: UIAlertAction!) in
                                self.dismiss(animated: true, completion: nil)
                        })
                        
                        self.present(alert, animated: true, completion: nil)
                    } else { print("not insert document")}
                }
            } else {
                print("not upload")
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.imgEventView.image = image
            self.isImageSelected = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}
