//
//  CategoryTableViewCell.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    //MARK: Properties
    var category: EntityCategory!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var gradient: Gradient!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
