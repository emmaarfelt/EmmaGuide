//
//  OpeningHours.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 25/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

@IBDesignable class OpeningHoursView: UIView {

    var view:UIView!;
    
    @IBOutlet weak var openingHours: UILabel!
    
    @IBAction func closeWindow(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OpeningHoursView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = true;
        openingHours.adjustsFontSizeToFitWidth = true
        
    }

}
