//
//  DraggableView.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

//Values for animation
let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle

protocol DraggableViewDelegate {
    func cardSwiped(_ card: UIView) -> Void
    func cardTapped(_ card: UIView) -> Void
}

//The DraggableView represents the cards that are swiped.
class DraggableView: UIView {
    var delegate: DraggableViewDelegate!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var tapGestrueRecognizer: UITapGestureRecognizer!
    var originPoint: CGPoint!
    var xFromCenter: Float!
    var yFromCenter: Float!
    
    var cardview: CardView! //Since the draggable view are designed by the CardView custom nib
    var name: UILabel!
    var img: UIImageView!
    var desc: UILabel!
    var distance: UILabel!
    
    var rest: Entity! 
    

    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //MARK: Layout of subview
        cardview =  CardView(frame: frame)
        self.addSubview(cardview!)
        cardview.bindFrameToSuperviewBounds()
        
        //Set outlets of DraggableView to the CardView outlets
        name = cardview.name
        img = cardview.image
        desc = cardview.desc
        distance = cardview.distance
        
        //Setup Gestures
        tapGestrueRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.beingTapped(_:)))
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        self.addGestureRecognizer(tapGestrueRecognizer)

        xFromCenter = 0
        yFromCenter = 0
    }
    
    //What happens when the card is being dragged
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) -> Void {
        xFromCenter = Float(gestureRecognizer.translation(in: self).x)
        yFromCenter = Float(gestureRecognizer.translation(in: self).y)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.began:
            self.originPoint = self.center
        case UIGestureRecognizerState.changed:
            let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = ROTATION_ANGLE * rotationStrength
            let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)

            self.center = CGPoint(x: self.originPoint.x + CGFloat(xFromCenter), y: self.originPoint.y + CGFloat(yFromCenter))

            let transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
            let scaleTransform = transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
            self.transform = scaleTransform
        case UIGestureRecognizerState.ended:
            self.afterSwipeAction()
        case UIGestureRecognizerState.possible:
            fallthrough
        case UIGestureRecognizerState.cancelled:
            fallthrough
        case UIGestureRecognizerState.failed:
            fallthrough
        default:
            break
        }
    }

    //Reset the card to it's original tranformation to avoid mistakes, if the card is reloaded
    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else {
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.center = self.originPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
    }
    
    func rightAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: 500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
                self.center = self.originPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
        })
        delegate.cardSwiped(self)
    }

    func leftAction() -> Void {
        let finishPoint: CGPoint = CGPoint(x: -500, y: 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animate(withDuration: 0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
                self.center = self.originPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
        })
        delegate.cardSwiped(self)
    }
    
    @objc func beingTapped(_ gestureRecognizer: UITapGestureRecognizer) -> Void {
        delegate.cardTapped(self)
    }
    
}
