//
//  ViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

let MAX_BUFFER_SIZE = 3
let CARD_HEIGHT: CGFloat = 426
let CARD_WIDTH: CGFloat = 290

class SwipeViewController: UIViewController, DraggableViewDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var catName: UILabel!
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var allCards: [DraggableView]!
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    
    var viewCategory: EntityCategory!
    var restaurants : [Restaurants]!
    
    required init?(coder aDecoder: NSCoder)
    {
        self.viewCategory = EntityCategory(name: "Default Category", photo: #imageLiteral(resourceName: "dinner"), color: UIColor.blue, entities: [])
        super.init(coder: aDecoder);
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup view to align with Category
        self.view.backgroundColor = viewCategory.color!.withAlphaComponent(1.0)
        catName.text = viewCategory.name
        restaurants = viewCategory.entities
        
        // Setup cards
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        loadCards()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDraggableViewWithDataAtIndex(_ index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: (backgroundView.frame.size.width - CARD_WIDTH)/2, y: (backgroundView.frame.size.height - CARD_HEIGHT)/2, width: CARD_WIDTH, height: CARD_HEIGHT))
        
        //Setup View
        draggableView.layer.shadowRadius = 5;
        draggableView.layer.shadowOpacity = 0.2;
        draggableView.layer.shadowOffset = CGSize(width: 1, height: 1)
        draggableView.layer.shadowColor = UIColor(red:0.79, green:0.82, blue:0.82, alpha:1.0).cgColor
        
        //Setup Data
        draggableView.rest = restaurants[index]
        draggableView.name.text = restaurants[index].name
        draggableView.img.image = restaurants[index].photo
        draggableView.desc.text = restaurants[index].formatted_address
        
        /*let distance = (calculateDistance(restaurant: draggableView.rest) / 1000).roundTo(places: 1)
        draggableView.distance.text = "\(distance) kilometer"*/
        
        draggableView.delegate = self
        return draggableView
    }
    
    func loadCards() -> Void {
        if restaurants.count > 0 {
            let numLoadedCardsCap = restaurants.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : restaurants.count
            for i in 0 ..< restaurants.count {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            for i in 0 ..< loadedCards.count {
                switch i {
                case 0:
                    backgroundView.addSubview(loadedCards[i])
                default:
                    backgroundView.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }
    
    func cardSwiped(_ card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            backgroundView.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
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

