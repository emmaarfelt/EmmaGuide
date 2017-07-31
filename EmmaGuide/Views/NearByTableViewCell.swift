//
//  NearByTableViewCell.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 30/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class NearByTableViewCell: UITableViewCell {

    @IBOutlet var arrow: UIImageView!
    @IBOutlet var entityName: UILabel!
    var entity: Entity!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
