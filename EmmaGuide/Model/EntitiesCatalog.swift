//
//  RestaurantCatelog.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 26/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import Foundation

var ENTITIES = [Entity]()

class EntitiesCatalog {
    struct EntityFromFile {
        var name : String
        var placeID : String
        var desc : String
        var category : String
    }
    
    //MARK: Load all restaurants from the txt-file
    static func loadAllReferences() -> Void {
        var refRestaurants = [EntityFromFile]()
        
        if let path = Bundle.main.path(forResource: "restaurantIDs", ofType: "txt") {
            let contents = try! String(contentsOfFile: path)
            let restaurants = contents.components(separatedBy: "\n")
            
            for rest in restaurants {
                if rest == "" { break }
                let elements = rest.components(separatedBy: ":")
                let restaurant = EntityFromFile(name: elements[0], placeID: elements[1], desc: elements[2], category: elements[3])
                refRestaurants.append(restaurant)
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                // Do some time consuming task in this background thread
                for entity in refRestaurants {
                    guard let apiEntity = APICaller().fetchRestaurantDetails(placeId: entity.placeID) else {continue}
                    
                    guard let currentEntity = Entity(name: apiEntity.name,
                                              formatted_address: apiEntity.formatted_address,
                                              website: apiEntity.website,
                                              location: ((apiEntity.geometry.location.lat,apiEntity.geometry.location.lng)),
                                              opening_hours: apiEntity.opening_hours?.weekday_text,
                                              photoRef: (apiEntity.photos?[0].photo_reference),
                                              comment: entity.desc,
                                              category: entity.category) else  { continue }
                    ENTITIES.append(currentEntity)
                    print(entity.name)
                }
            }
        } else {
            print("File not found")
            return
        }
    }
    
    //Create 'Restaurants' objects for each object in the specified category
    func getRestaurants(category: String) -> [Entity]? {
        var categoryRestaurants = [Entity]()
        let filteredRest = ENTITIES.filter { $0.category == category }
       
        for rest in filteredRest {
            categoryRestaurants.append(rest)
        }
        
        return categoryRestaurants
    }
    
}
