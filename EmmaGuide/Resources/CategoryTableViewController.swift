//
//  CategoryTableViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    //MARK: Properties
    var categories = [Category]()
    var gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sample data.
        loadSampleMeals()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = categories[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.gradient.FirstColor = meal.color

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let subjectCell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell, let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "SwipeRestaurants") as? SwipeViewController{
            //This is a bonus, I will be showing at destionation controller the same text of the cell from where it comes...
            destinationViewController.category = subjectCell.nameLabel.text
            destinationViewController.bgColor = subjectCell.gradient.FirstColor
            //Then just push the controller into the view hierarchy
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }

    private func loadSampleMeals() {
        
        let photo1 = UIImage(named: "lunch")
        let photo2 = UIImage(named: "dinner")
        let photo3 = UIImage(named: "brunch")
        let photo4 = UIImage(named: "cocktails")
        
        guard let meal1 = Category(name: "Dinner", photo: photo2, color: UIColor(red:0.01, green:0.24, blue:0.26, alpha:0.6)) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Category(name: "Lunch", photo: photo1, color: UIColor(red:0.34, green:0.20, blue:0.16, alpha:0.6)) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Category(name: "Brunch", photo: photo3, color: UIColor(red:0.35, green:0.20, blue:0.11, alpha:0.6)) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal4 = Category(name: "Cocktails", photo: photo4, color: UIColor(red:0.43, green:0.55, blue:0.55, alpha:0.6)) else {
            fatalError("Unable to instantiate meal2")
        }
        
        categories += [meal1, meal2, meal3, meal4]
    }
    

}
