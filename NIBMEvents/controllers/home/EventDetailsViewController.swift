//
//  EventDetailsViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 3/2/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class EventDetailsViewController: UIViewController {
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var imgPublisher: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPublisher: UILabel!

    var eventDetails: CustomEvent?
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    @IBAction func onViewLocation(_ sender: NEButton) {
        let locationManager = LocationManager()
        locationManager.getPlace { [weak self](location) in
            guard let `self` = self else { return }
            if location != nil {
                guard let latitudes = self.eventDetails?.latitudes,
                let longitudes = self.eventDetails?.longitudes else { return }
                
                let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudes, longitude: longitudes)))
                source.name = self.eventDetails!.title!
                MKMapItem.openMaps(with: [source])
            }
        }
    }
    
    private func updateUI() {
        self.eventDetails = CustomEvent(event: UserDefaults.standard.value(
            forKey: "selectedEvent") as! [String: Any])
        guard let event = eventDetails else { return }
        
        let imgEventUrl = URL(string: event.eventImageUrl!)
        self.imgEvent.kf.indicatorType = .activity
        self.imgEvent.kf.setImage(with: imgEventUrl)
        
        let imgPublisherUrl = URL(string: event.publisherImageUrl!)
        self.imgPublisher.kf.indicatorType = .activity
        self.imgPublisher.kf.setImage(with: imgPublisherUrl)
        self.imgPublisher.layer.cornerRadius = imgPublisher.bounds.width / 2.0
        self.imgPublisher.layer.masksToBounds = true
        
        self.lblTitle.text = event.title
        self.lblBody.text = event.body
        self.lblPublisher.text = event.publisherName
        self.lblTime.text = event.timeStamp?.description.components(separatedBy: "+")[0]
    }
}
