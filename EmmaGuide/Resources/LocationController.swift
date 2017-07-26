//
//  LocationController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 26/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController : NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var userCurrentLocation = CLLocation()
    
    func setupLocationManager() -> Void {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userCurrentLocation = CLLocation(latitude: (locValue.latitude),longitude: (locValue.longitude))
    }
    
    func getUserCurrentLocation() -> CLLocation {
        locationManager.requestLocation()
        return userCurrentLocation
    }
    
    func getRestaurantCoordinates(restaurant: Restaurants) -> CLLocation {
        return CLLocation(latitude: CLLocationDegrees(restaurant.location.0), longitude: CLLocationDegrees(restaurant.location.1))
    }
    
    func calculateDistance(currentCoordinate: CLLocation, restCoordinate: CLLocation) -> CLLocationDistance {
        return currentCoordinate.distance(from: restCoordinate)
    }
    
}




