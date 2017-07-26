//
//  Meal.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit


class EntityCategory {
    
    //MARK: Properties
    
    var name: String?
    var photo: UIImage?
    var color: UIColor?
    var entities: [Restaurants]?
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, color: UIColor, entities: [Restaurants]) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.color = color
        self.entities = entities
    }
    
    static func generateCategories() -> [EntityCategory] {
        //Setup Photos
        let dinnerPhoto = UIImage(named: "dinner")
        let lunchPhoto = UIImage(named: "lunch")
        let brunchPhoto = UIImage(named: "brunch")
        let cocktailsPhoto = UIImage(named: "cocktails")
        
        //Setup Entities
        let dinnerEntites = RestaurantCatalog().getRestaurants(category: "Dinner")
        let lunchEntites = RestaurantCatalog().getRestaurants(category: "Lunch")
        let brunchEntites = RestaurantCatalog().getRestaurants(category: "Brunch")
        let cocktailsEntites = RestaurantCatalog().getRestaurants(category: "Cocktails")
        
        guard let dinner = EntityCategory(name: "Dinner", photo: dinnerPhoto, color: UIColor(red:0.01, green:0.24, blue:0.26, alpha:0.6), entities: dinnerEntites!) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let lunch = EntityCategory(name: "Lunch", photo: lunchPhoto, color: UIColor(red:0.34, green:0.20, blue:0.16, alpha:0.6), entities: lunchEntites!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let brunch = EntityCategory(name: "Brunch", photo: brunchPhoto, color: UIColor(red:0.35, green:0.20, blue:0.11, alpha:0.6), entities: brunchEntites!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let cocktails = EntityCategory(name: "Cocktails", photo: cocktailsPhoto, color: UIColor(red:0.43, green:0.55, blue:0.55, alpha:0.6), entities: cocktailsEntites!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        return [dinner, lunch, brunch, cocktails]
    }
}
