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
    
    var restaurant: Entity?
    
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
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("Show Alert with link to settings")
        case .restricted:
            // Nothing you can do, app cannot use location services
            break
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        userCurrentLocation = location
    }
 
    func getUserLocation() -> CLLocation? {
        locationManager.startUpdatingLocation()
        guard let userLocation = locationManager.location else { return nil }
        return userLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    
    func getRestaurantCoordinates(rest: Entity) -> CLLocation {
        return CLLocation(latitude: CLLocationDegrees(rest.location.0), longitude: CLLocationDegrees(rest.location.1))
    }
    
    func getRestaurantCoordinates2D(rest: Entity) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(CLLocationDegrees(rest.location.0), CLLocationDegrees(rest.location.1))
    }
    
    func getDistanceToRestaurant(rest: Entity) -> CLLocationDistance? {
        let restLocation = getRestaurantCoordinates(rest: rest)
        guard let userLocation = locationManager.location else { return nil }
        
        return (userLocation.distance(from: restLocation) / 1000).roundTo(places: 1)
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




