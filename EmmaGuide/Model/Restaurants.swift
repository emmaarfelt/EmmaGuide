//
//  Restaurants.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 17/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit


class Restaurants {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var desc: String
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, desc: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.desc = desc
    }
    
}
