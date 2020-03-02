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
    // - Private
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

// MARK: - Get Placemark
extension LocationManager: CLLocationManagerDelegate {
    func getPlace(completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        let coordinates = self.getCoordinates()
        
        let location: CLLocation? = CLLocation(latitude: 6.931970, longitude: 79.857750) // Due to a coordinates returns nil mock the CLLocation
        geocoder.reverseGeocodeLocation(location!) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
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
                locationManager.startUpdatingLocation()
                location = locationManager.location
                return location
            }
        } else {
            print("Please turn on your location services from settings.")
        }

        return nil
    }
}
