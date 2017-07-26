//
//  APICaller.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 21/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import Foundation

class APICaller {
    struct Result : Codable {
        var result : Restaurant
    }
    
    struct Restaurant : Codable {
        var name: String
        var formatted_address: String
        var website: String
        var geometry : Geometry
        var opening_hours: OpeningHours
        var photos: [Photo]
    }
    
    struct Geometry : Codable {
        var location: Location
    }
    
    struct Location : Codable {
        var lat: Float
        var lng: Float
    }

    struct OpeningHours : Codable {
      var weekday_text: [String]
    }
    
    struct Photo : Codable {
        var photo_reference: String
    }

    func fetchRestaurantDetails(placeId: String) -> Restaurant? {
        let jsonURLString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=AIzaSyDr98H9_ovlc25tjjPtJDDOw00FcNepCEY&language=da"
        guard let url = URL(string: jsonURLString) else { return nil}
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let (data, response, error) = session.synchronousDataTask(with: url)
        
        guard error == nil else {
            print("error calling GET")
            print(error!)
            return nil
        }
        // make sure we got data
        guard let responseData = data else {
            print("Error: did not receive data")
            return nil
        }
        // parse the result as JSON, since that's what the API provides
        do {
            let place = try JSONDecoder().decode(Result.self, from: responseData)
            return place.result
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
        
    }
    
    func fetchRestaurantPhoto(photos: [Photo]) -> UIImage? {
        let photoRef = photos[0].photo_reference
        let jsonURLString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=\(photoRef)&key=AIzaSyDr98H9_ovlc25tjjPtJDDOw00FcNepCEY"
        guard let url = URL(string: jsonURLString) else {return nil  }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let (data, _, _) = session.synchronousDataTask(with: url)
        if let image = UIImage(data:data!) {
            return image
        } else {
            return nil
        }
        
    }

}
