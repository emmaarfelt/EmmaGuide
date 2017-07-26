//
//  Gradient.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

@IBDesignable
class Gradient: UIView {
    
    override class var layerClass: AnyClass {
        get {return CAGradientLayer.self}
    }

    @IBInspectable var FirstColor : UIColor = UIColor.black {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
    }
    
}
