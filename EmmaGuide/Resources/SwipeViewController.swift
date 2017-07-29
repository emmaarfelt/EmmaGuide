//
//  ViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

let MAX_BUFFER_SIZE = 1
let CARD_CACHE = NSCache<AnyObject, AnyObject>()

class SwipeViewController: UIViewController, DraggableViewDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var catName: UILabel!
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var cardNumber : Int = 0
    var loadedCards: [DraggableView]!
    
    var viewCategory: EntityCategory!
    var restaurants : [Restaurants]!
    var CARD_HEIGHT : CGFloat!
    var CARD_WIDTH: CGFloat!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup view to align with Category
        self.view.backgroundColor = viewCategory.color!.withAlphaComponent(1.0)
        catName.text = viewCategory.name
        restaurants = viewCategory.entities
        
        // Setup cards
        //allCards = []
        loadedCards = []
        
        
        CARD_HEIGHT  = ((backgroundView.frame.height / 2) + (catName.frame.height * 1.7))
        CARD_WIDTH = (backgroundView.frame.width - (catName.frame.width / 4))
        
        loadCards()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDraggableViewWithDataAtIndex(_ index: NSInteger) -> DraggableView {
        //Create key for Cache
        let key = restaurants[index].name
        
        //Check if card already exists
        if let card = CARD_CACHE.object(forKey: key as AnyObject) {
            let card = card as! DraggableView
            //We need to recalculate the distance if the user has moved
            let distance = LocationController().getDistanceToRestaurant(rest: card.rest)
            card.distance.text = "\(distance) kilometer"

            card.delegate = self
            return card
        } else {
            //If the card does not exist in cache we create the view
            let draggableView = DraggableView(frame: CGRect(x: (backgroundView.frame.size.width - CARD_WIDTH)/2, y: (backgroundView.frame.size.height - CARD_HEIGHT)/2, width: CARD_WIDTH, height: CARD_HEIGHT))
            
            //Setup View
            draggableView.layer.shadowRadius = 5;
            draggableView.layer.shadowOpacity = 0.2;
            draggableView.layer.shadowOffset = CGSize(width: 1, height: 1)
            draggableView.layer.shadowColor = UIColor.black.cgColor
            
            //Setup Data
            draggableView.rest = restaurants[index]
            draggableView.name.text = restaurants[index].name?.uppercased()
            draggableView.name.addTextSpacing(spacing: 3.0)
            draggableView.name.adjustsFontSizeToFitWidth = true
            draggableView.desc.text = restaurants[index].comment
            draggableView.desc.addLineSpacing(spacing: 1.5)
            draggableView.desc.numberOfLines = 0
            draggableView.sizeToFit()
            
            //Setup Image
            let photoReference = restaurants[index].photoRef
            draggableView.img.image = APICaller().fetchRestaurantPhoto(photoRef: photoReference)
            
        
            //Calculate the distance to the Restaurant
            let distance = LocationController().getDistanceToRestaurant(rest: draggableView.rest)
            draggableView.distance.text = "\(distance) kilometer"
            
            draggableView.delegate = self
            
            //Add the new view to the Cache
            CARD_CACHE.setObject(draggableView, forKey: key as AnyObject)
            return draggableView
        }
    }
    
    func loadCards() -> Void {
        if loadedCards.isEmpty {
            for _ in 0 ... MAX_BUFFER_SIZE {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(cardNumber)
                loadedCards.append(newCard)
                switch cardNumber {
                case 0:
                    backgroundView.addSubview(loadedCards[cardNumber])
                default:
                    backgroundView.insertSubview(loadedCards[cardNumber], belowSubview: loadedCards[cardNumber - 1])
                }
                cardNumber += 1
            }
        } else {
            let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(cardNumber)
            loadedCards.append(newCard)
            backgroundView.insertSubview(loadedCards[cardNumber], belowSubview: loadedCards[cardNumber - 1])
            cardNumber += 1
        }
    }
    
    func cardSwiped(_ card: UIView) -> Void {
        if cardNumber < restaurants.count {
            loadCards()
        }
    }
    
    func cardTapped(_ card: UIView) {
        if let subjectCard = card as? DraggableView, let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "RestaurantView") as? RestaurantViewController{
            
            destinationViewController.restaurant = subjectCard.rest!
            
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
}

