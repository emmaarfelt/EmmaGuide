//
//  LocationController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 26/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationController : UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var userCurrentLocation = CLLocation()
    let annotation = MKPointAnnotation()
    
    var restaurant: Restaurants?
    
    @IBOutlet weak var restName: UILabel!
    @IBOutlet var map: MKMapView!
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func showRoute(_ sender: UIButton) {
        showRoute()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restName.text = restaurant!.name
        restName.adjustsFontSizeToFitWidth = true
        
        let restaurantCoords = getRestaurantCoordinates2D(rest: restaurant!)
        annotation.coordinate = restaurantCoords
        map.addAnnotation(annotation)
        
        //Set map to center on entity
        let span = MKCoordinateSpanMake(0.025, 0.025)
        let region = MKCoordinateRegion(center: restaurantCoords, span: span)
        map.setRegion(region, animated: true)
    }
    
    
    func setupLocationManager() -> Void {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userCurrentLocation = CLLocation(latitude: (locValue.latitude),longitude: (locValue.longitude))
    }
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    
    func getRestaurantCoordinates(rest: Restaurants) -> CLLocation {
        return CLLocation(latitude: CLLocationDegrees(rest.location!.0), longitude: CLLocationDegrees(rest.location!.1))
    }
    
    func getRestaurantCoordinates2D(rest: Restaurants) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(CLLocationDegrees(rest.location!.0), CLLocationDegrees(rest.location!.1))
    }
    
    func calculateDistance(currentCoordinate: CLLocation, restCoordinate: CLLocation) -> CLLocationDistance {
        return currentCoordinate.distance(from: restCoordinate)
    }
    
    func getDistanceToRestaurant(rest: Restaurants) -> CLLocationDistance {
        let restLocation = getRestaurantCoordinates(rest: rest)
        let userLocation = locationManager.location!
        
        return ((calculateDistance(currentCoordinate: userLocation, restCoordinate: restLocation)) / 1000).roundTo(places: 1)
    }
    
    func showRoute() {
        let entityCoords = restaurant?.location
        
        //Setup map
        let directionsURL = "comgooglemaps://?daddr=\(entityCoords!.0),\(entityCoords!.1)&travelmode=bicycling"
        
        if let url = URL(string: directionsURL) {
            UIApplication.shared.openURL(url)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
}




