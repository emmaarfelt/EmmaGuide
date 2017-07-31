//
//  RestaurantCatelog.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 26/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import Foundation

var REF_RESTAURANTS = EntitiesCatalog().loadAllReferences()

class EntitiesCatalog {
    
    struct Restaurant {
        var name : String
        var placeID : String
        var desc : String
        var category : String
    }
    
    
    //MARK: Load all restaurants from the txt-file
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
    
    //Create 'Restaurants' objects for each object in the specified category
    func getRestaurants(category: String) -> [Entity]? {
        var categoryRestaurants = [Entity]()
        let filteredRest = REF_RESTAURANTS?.filter { $0.category == category }
       
        for rest in filteredRest! {
            guard let apiRest = APICaller().fetchRestaurantDetails(placeId: rest.placeID) else { continue }
            
            //Remove country from address
            let formatAddr = apiRest.formatted_address.components(separatedBy: ", Danmark")[0]
            let entity = Entity(name: apiRest.name,
                                    formatted_address: formatAddr,
                                    website: apiRest.website,
                                    location: ((apiRest.geometry.location.lat,apiRest.geometry.location.lng)),
                                    opening_hours: apiRest.opening_hours.weekday_text,
                                    photoRef: apiRest.photos![0].photo_reference,
                                    comment: rest.desc)
            categoryRestaurants.append(entity!)
        }
        print("Loaded\(category)")
        return categoryRestaurants.shuffled() //Shuffle to make the order of the cards different at each load
    }
    
}
