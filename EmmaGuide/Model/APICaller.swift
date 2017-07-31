//
//  APICaller.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 21/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import Foundation

//Create Cache for both images and places information
let IMAGE_CACHE = NSCache<AnyObject, UIImage>()
let TEXT_CACHE = NSCache<AnyObject, AnyObject>()

class APICaller {
    
    //MARK: Structure for the JSON parsing
    struct Result : Codable {
        var result : Restaurant
    }
    
    struct Restaurant : Codable {
        var name: String
        var formatted_address: String
        var website: String
        var geometry : Geometry
        var opening_hours: OpeningHours?
        var photos: [Photo]?
    }
    
    struct Geometry : Codable {
        var location: Location
    }
    
    struct Location : Codable {
        var lat: Float
        var lng: Float
    }

    struct OpeningHours : Codable {
      var weekday_text: [String]?
    }
    
    struct Photo : Codable {
        var photo_reference: String?
    }

    //MARK: Get Details from Google Places API for specified placeId
    func fetchRestaurantDetails(placeId: String) -> Restaurant? {
        
        if let place = TEXT_CACHE.object(forKey: placeId as AnyObject) {
            return place as? APICaller.Restaurant
        } else {
            let jsonURLString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=KEY&language=da"
            guard let url = URL(string: jsonURLString) else { return nil}
            
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let (data, _, error) = session.synchronousDataTask(with: url)
            
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
            // parse the result as JSON
            do {
                var place = try JSONDecoder().decode(Result.self, from: responseData)
                place.result.formatted_address = place.result.formatted_address.components(separatedBy: ", Danmark")[0]
                TEXT_CACHE.setObject(place.result as AnyObject, forKey: placeId as AnyObject)
                return place.result
            } catch  {
                print("error trying to convert data to JSON\(placeId)")
                return nil
            }
        }
    }
    
    //MARK: Get photo from Google Places API with specified photoreference
    func fetchRestaurantPhoto(photoRef: String) -> UIImage? {
        if let photo = IMAGE_CACHE.object(forKey: photoRef as AnyObject) {
            return photo
        } else {
            let jsonURLString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=600&photoreference=\(photoRef)&key=KEY"
            guard let url = URL(string: jsonURLString) else {return nil  }
            
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let (data, _, _) = session.synchronousDataTask(with: url)
            if let image = UIImage(data:data!) {
                IMAGE_CACHE.setObject(image, forKey: photoRef as AnyObject)
                return image
            } else {
                return nil
            }
        }
        
    }

}
