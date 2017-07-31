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
    var gradient = CAGradientLayer()
    var categories = [EntityCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = EntityCategory.generateCategories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell.")
        }
        
        // Configure the cell...
        cell.category = categories[indexPath.row]
        cell.nameLabel.text = cell.category.name
        cell.photoImageView.image = cell.category.photo
        cell.gradient.FirstColor = cell.category.color!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let subjectCell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell, let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "SwipeRestaurants") as? SwipeViewController{
            
            destinationViewController.viewCategory = subjectCell.category
            
            navigationController?.pushViewController(destinationViewController, animated: true)
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}
