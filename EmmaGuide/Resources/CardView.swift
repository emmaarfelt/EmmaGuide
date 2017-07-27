//
//  SimpleCustomView.swift
//  CustomXIBSwift
//
//  Created by Karthik Prabhu Alagu on 06/08/15.
//  Copyright © 2015 KPALAGU. All rights reserved.
//


import UIKit

@IBDesignable class CardView:UIView
{
    var view:UIView!;
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
   @IBInspectable var lblTitleText : String?
        {
        get{
            return lblTitle.text;
        }
        set(lblTitleText)
        {
            lblTitle.text = lblTitleText!;
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CardView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = true;
        desc.adjustsFontSizeToFitWidth = true

    }


    
}
