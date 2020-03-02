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
    
    private let locationManager = LocationManager()

    @IBOutlet weak var btnEventLocation: NEButton!
    @IBOutlet weak var btnDateTime: NEButton!
    
    @IBOutlet weak var txtEventTitle: NETextField!
    @IBOutlet weak var txtEventDescription: NETextField!
    @IBOutlet weak var txtContactNumber: NETextField!
    
    var isNewEventImage: Bool = false
    var isDateTimeSelected: Bool = false
    var isImageSelected: Bool = true

    private var dateTime: Date = Date()
    
    private var event: CustomEvent?

    override func viewDidLoad() {
        self.updateUI()
    }

    @IBAction func onChangeLocation(_ sender: NEButton) {
        self.btnEventLocation.showLoading()
        self.locationManager.getPlace { [weak self](location) in
            guard let `self` = self else { return }
            if location != nil {
                self.btnEventLocation.hideLoading()
                self.btnEventLocation.setTitle(location?.name, for: .normal)
            }
        }
    }

    @IBAction func onChangeDateTime(_ sender: NEButton) {
        let picker = DateTimePicker.show()
        picker.is12HourFormat = true
        picker.timeZone = TimeZone.current
        picker.completionHandler = { date in
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
        
        if !self.isDateTimeSelected {
            let alert = NotificationManager.sharedInstance.showAlert(
                header: "Add Event Failed",
                body: "The following date and time field is missing or invalid.", action: "Okay")
            
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
        self.setEventData()
        self.txtEventTitle.setLeftPaddingPoints(5)
        self.txtEventTitle.setRightPaddingPoints(5)
        
        self.txtContactNumber.setLeftPaddingPoints(5)
        self.txtContactNumber.setRightPaddingPoints(5)
        
        self.txtEventDescription.setLeftPaddingPoints(5)
        self.txtEventDescription.setRightPaddingPoints(5)
        
        guard let event = event else { return }
        let omitTimezone = event.timeStamp!.description.components(separatedBy: "+")

        let imgUrl = URL(string: event.eventImageUrl!)
        self.imgEventView.kf.indicatorType = .activity
        self.imgEventView.kf.setImage(with: imgUrl)

        self.btnEventLocation.setTitle(event.publishedLocation, for: .normal)
        self.btnDateTime.setTitle(omitTimezone[0], for: .normal)
        self.txtEventTitle.text = event.title
        self.txtEventDescription.text = event.body
        self.txtContactNumber.text = event.publisherContactNumber
    }
    
    private func setEventData() {
        self.event = CustomEvent(event: UserDefaults.standard.value(
            forKey: "eventData") as! [String: Any])
    }
    
    private func invokeServices() {
        SVProgressHUD.show(withStatus: "Please wait")
        SVProgressHUD.setDefaultMaskType(.clear)
        
        guard let user = AuthManager.sharedInstance.user
            else { return }

        DatabaseManager.sharedInstance.uploadImage(image: self.imgEventView.image!, email: user.email!, type: .event) { (url, error) in
            if url != nil {
                guard let event = self.event else { return }
                let coordinates = self.locationManager.exposedLocation?.coordinate
                let data: [String: Any] = [
                    "publishedLocation": self.btnEventLocation.titleLabel?.text!,
                    "coordinates": GeoPoint(latitude: coordinates!.latitude, longitude: coordinates!.longitude),
                    "publisherContactNumber": self.txtContactNumber.text!,
                    "timeStamp": Timestamp(date: self.dateTime),
                    "title": self.txtEventTitle.text!,
                    "body": self.txtEventDescription.text!,
                    "eventImageUrl": url!
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
