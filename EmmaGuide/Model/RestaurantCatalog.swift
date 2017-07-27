//
//  RestaurantCatelog.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 26/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import Foundation

class RestaurantCatalog {
    
    struct Restaurant {
        var name : String
        var placeID : String
        var desc : String
        var category : String
    }
    
    
    func loadAllReferences() -> [Restaurant]? {
        var refRestaurants = [Restaurant]()
        
        if let path = Bundle.main.path(forResource: "restaurantIDs", ofType: "txt") {
            let contents = try! String(contentsOfFile: path)
            let restaurants = contents.components(separatedBy: "\n")
            
            for rest in restaurants {
                if rest == "" { break }
                let elements = rest.components(separatedBy: ":")
                let restaurant = Restaurant(name: elements[0], placeID: elements[1], desc: elements[2], category: elements[3])
                refRestaurants.append(restaurant)
            }
            return refRestaurants
        } else {
            print("File not found")
            return nil
        }
        
    }
    
    func getRestaurants(category: String) -> [Restaurants]? {
        guard let refRestaurants = loadAllReferences() else { return nil }
        var categoryRestaurants = [Restaurants]()
        let filteredRest = refRestaurants.filter { $0.category == category }
       
        for rest in filteredRest {
            guard let apiRest = APICaller().fetchRestaurantDetails(placeId: rest.placeID) else {return nil}
            guard let apiPhoto = APICaller().fetchRestaurantPhoto(photos: (apiRest.photos)) else {return nil}
            
            //Remove country from address
            let formatAddr = apiRest.formatted_address.components(separatedBy: ", Danmark")[0]
            
            let entity = Restaurants(name: apiRest.name,
                                    formatted_address: formatAddr,
                                    website: apiRest.website,
                                    location: ((apiRest.geometry.location.lat,apiRest.geometry.location.lng)),
                                    opening_hours: apiRest.opening_hours.weekday_text,
                                    photo: apiPhoto,
                                    comment: rest.desc)
            categoryRestaurants.append(entity!)
        }
        
        return categoryRestaurants.shuffled()
    }
    
}
