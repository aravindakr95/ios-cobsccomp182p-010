//
//  LocationViewController.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 3/2/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func getPlace(completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        let coordinates = self.getCoordinates()
        
        geocoder.reverseGeocodeLocation(coordinates!) { placemarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            completion(placemark)
        }
    }
    
    func getCoordinates() -> (CLLocation?) {
        var location: CLLocation?
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied {
                locationManager.stopUpdatingLocation()
                print("You have denied to access your current location.")
            }
            
            let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            
            if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
                location = locationManager.location
                return location
            }
        } else {
            print("Please turn on your location services from settings.")
        }

        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            print("Users: location: \(loc)")
        }
    }
}
