//
//  SimpleCustomView.swift
//  CustomXIBSwift
//
//  Created by Karthik Prabhu Alagu on 06/08/15.
//  Copyright © 2015 KPALAGU. All rights reserved.
//


import UIKit

extension UIView {
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}


@IBDesignable class SimpleCustomView:UIView
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
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SimpleCustomView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.layer.cornerRadius = 4
    }

    
}
