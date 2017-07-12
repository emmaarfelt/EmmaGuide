//
//  ViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class GradientViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.cyan.cgColor, UIColor.clear.cgColor]
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
    }

}
