//
//  CardView.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 15/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
    }

}
