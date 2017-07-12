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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeCard(_ sender: UIPanGestureRecognizer) {
        guard let card = sender.view else { return }
        let xFromCenter = card.center.x - view.center.x
        let rotationAngle = xFromCenter/view.frame.width * 0.61
        let position = sender.translation(in: view)
        
        card.center = CGPoint(x: view.center.x + position.x, y: view.center.y + position.y)
        card.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        if sender.state == UIGestureRecognizerState.ended {
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0.0
                })
            } else if card.center.x > (view.frame.width - 75) {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0.0
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = self.view.center})
                card.transform = CGAffineTransform.identity
            }
           
        }
        
    }
    

}
