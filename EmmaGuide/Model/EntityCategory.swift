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
        let takeawayPhoto = UIImage(named: "takeaway")
        let spaPhoto = UIImage(named: "spa")
        let coffeePhoto = UIImage(named: "coffee")
        let workPhoto = UIImage(named: "workstation")
        
        //Setup Entities
        let dinnerEntites = RestaurantCatalog().getRestaurants(category: "Dinner")
        let lunchEntites = RestaurantCatalog().getRestaurants(category: "Lunch")
        let brunchEntites = RestaurantCatalog().getRestaurants(category: "Brunch")
        let cocktailsEntites = RestaurantCatalog().getRestaurants(category: "Cocktails")
        let takeawayEntities = RestaurantCatalog().getRestaurants(category: "TakeAway")
        let spaEntities = RestaurantCatalog().getRestaurants(category: "Spa")
        let coffeeEntities = RestaurantCatalog().getRestaurants(category: "Coffee")
        let workEntities = RestaurantCatalog().getRestaurants(category: "Workstation")
        
        guard let dinner = EntityCategory(name: "Middag", photo: dinnerPhoto, color: UIColor(red:0.02, green:0.15, blue:0.16, alpha:0.6), entities: dinnerEntites!) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let lunch = EntityCategory(name: "Frokost", photo: lunchPhoto, color: UIColor(red:0.27, green:0.40, blue:0.39, alpha:0.6), entities: lunchEntites!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let brunch = EntityCategory(name: "Brunch", photo: brunchPhoto, color: UIColor(red:0.49, green:0.16, blue:0.18, alpha:0.6), entities: brunchEntites!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let cocktails = EntityCategory(name: "Cocktails", photo: cocktailsPhoto, color: UIColor(red:0.62, green:0.53, blue:0.51, alpha:0.6), entities: cocktailsEntites!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let takeaway = EntityCategory(name: "Take Away", photo: takeawayPhoto, color: UIColor(red:0.75, green:0.57, blue:0.02, alpha:0.6), entities: takeawayEntities!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let spa = EntityCategory(name: "Spa", photo: spaPhoto, color: UIColor(red:0.15, green:0.03, blue:0.00, alpha:0.6), entities: spaEntities!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let coffee = EntityCategory(name: "Kaffebar", photo: coffeePhoto, color: UIColor(red:0.62, green:0.53, blue:0.51, alpha:0.6), entities: coffeeEntities!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let workstation = EntityCategory(name: "Kontor", photo: workPhoto, color: UIColor(red:0.27, green:0.40, blue:0.39, alpha:0.6), entities: workEntities!) else {
            fatalError("Unable to instantiate meal2")
        }
        
        return [dinner, brunch, lunch, takeaway, coffee, workstation, cocktails, spa]
    }
}
