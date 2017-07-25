//
//  APICaller.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 21/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import Foundation


extension URLSession {
    func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}

class APICaller {
    
    var rest : Restaurant!
    var restImg : UIImage!
    
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

    func fetchRestaurantDetails(placeId: String) -> Void {
        let jsonURLString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=APIKEY"
        guard let url = URL(string: jsonURLString) else { return}
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let (data, response, error) = session.synchronousDataTask(with: url)
        
        guard error == nil else {
            print("error calling GET")
            print(error!)
            return
        }
        // make sure we got data
        guard let responseData = data else {
            print("Error: did not receive data")
            return
        }
        // parse the result as JSON, since that's what the API provides
        do {
            let place = try JSONDecoder().decode(Result.self, from: responseData)
            self.rest = place.result
            self.restImg = fetchRestaurantPhoto(photos: place.result.photos)
        } catch  {
            print("error trying to convert data to JSON")
            return
        }
        
    }
    
    func fetchRestaurantPhoto(photos: [Photo]) -> UIImage {
        let photoRef = photos[0].photo_reference
        let jsonURLString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=\(photoRef)&key=APIKEY"
        guard let url = URL(string: jsonURLString) else {return #imageLiteral(resourceName: "brunch")
            
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let (data, _, _) = session.synchronousDataTask(with: url)
        if let image = UIImage(data:data!) {
            return image
        } else {
            return #imageLiteral(resourceName: "lunch")
        }
        
    }
    
    func createRestaurant(placeId: String) -> Restaurants {
        self.fetchRestaurantDetails(placeId: placeId)
        let rest = Restaurants(name: self.rest.name,
                               formatted_address: self.rest.formatted_address,
                               website: self.rest.website,
                               location: ((self.rest.geometry.location.lat,self.rest.geometry.location.lng)),
                               opening_hours: self.rest.opening_hours.weekday_text,
                               photo: self.restImg)
        return rest!
    }
}
