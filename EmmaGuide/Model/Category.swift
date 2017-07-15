//
//  Meal.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit


class Category {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var color: UIColor
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, color: UIColor) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.color = color
    }
}
