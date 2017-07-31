//
//  Restaurants.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 17/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit


class Entity {
    
    //MARK: Properties
    
    var name: String
    var formatted_address: String
    var website: String
    var location : (Float,Float)
    var opening_hours: [String]
    var photoRef: String?
    var comment: String
    var category: String
    
    //MARK: Initialization
    
    init?(name: String, formatted_address: String, website: String, location: (Float, Float), opening_hours: [String]?, photoRef: String?, comment: String, category: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.formatted_address = formatted_address
        self.website = website
        self.location = location
        self.opening_hours = opening_hours ?? ["ikke tilgængelige"]
        self.photoRef = photoRef ?? ""
        self.comment = comment
        self.category = category
    }
    
}
