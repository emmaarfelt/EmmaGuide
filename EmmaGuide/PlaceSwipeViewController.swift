//
//  PlaceSwipeViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 12/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class PlaceSwipeViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let position = sender.translation(in: view)
        card.center = CGPoint(x: view.center.x + position.x, y: view.center.y + position.y)
        
        if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.2, animations: {
            card.center = self.view.center})
        }
        
    }
    

}
