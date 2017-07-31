//
//  NearbyTableViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 30/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class NearbyTableViewController: UITableViewController {

    //To be implementet
    /*var nearByPlaces = [Entity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        findPlacesNearBy()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nearByPlaces.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NearByCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NearByTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        cell.entity = nearByPlaces[indexPath.row]
        cell.entityName.text = nearByPlaces[indexPath.row].name

        return cell
    }

    func findPlacesNearBy() {
        let userLocation = LocationController().getUserLocation()
        var allEntites = [Entity]()
        for cat in ENTITY_CATEGORIES{
            for entity in cat.entities! {
                allEntites.append(entity)
            }
        }
        
        for entity in allEntites {
            let distance = LocationController().getDistanceToRestaurant(rest: entity) as! Double
            if distance < 2.0 {
                nearByPlaces.append(entity)
            }
        }
    }*/
    
}
