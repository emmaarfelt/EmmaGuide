//
//  CardView.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 17/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

@IBDesignable class CardView:UIView
{
    //MARK: Properties
    var view:UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
   @IBInspectable var nameText : String?
        {
        get{
            return name.text;
        }
        set(lblTitleText)
        {
            name.text = nameText!;
        }
    }

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    //Load from specific Custom Nib file
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CardView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = true;
    }
    
}
