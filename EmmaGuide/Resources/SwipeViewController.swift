//
//  ViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

let MAX_BUFFER_SIZE = 2
let CARD_HEIGHT: CGFloat = 426
let CARD_WIDTH: CGFloat = 290

class SwipeViewController: UIViewController, DraggableViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    
    var allCards: [DraggableView]!
    
    var restaurants = [Restaurants]()
    
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    
    init(bgcolor: UIColor) {
        backgroundView.backgroundColor = bgcolor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadSampleMeals()
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        loadCards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(bgColor: UIColor) {
        backgroundView.backgroundColor = bgColor
    }
    
    func createDraggableViewWithDataAtIndex(_ index: NSInteger) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: (backgroundView.frame.size.width - CARD_WIDTH)/2, y: (backgroundView.frame.size.height - CARD_HEIGHT)/2, width: CARD_WIDTH, height: CARD_HEIGHT))
        draggableView.name.text = restaurants[index].name
        draggableView.img.image = restaurants[index].photo
        draggableView.desc.text = restaurants[index].desc
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
                if i > 0 {
                    backgroundView.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    backgroundView.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }
    
    func cardSwipedLeft(_ card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            backgroundView.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    func cardSwipedRight(_ card: UIView) -> Void {
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            backgroundView.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
    }
    
    private func loadSampleMeals() {
        
        let photo1 = UIImage(named: "lunch")
        let photo2 = UIImage(named: "dinner")
        let photo3 = UIImage(named: "brunch")
        let photo4 = UIImage(named: "cocktails")
        
        guard let meal1 = Restaurants(name: "Cofoco", photo: photo1, desc: "ie giuhr ksdfud sdhudschsdc") else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Restaurants(name: "Grillen", photo: photo2, desc: "ie giuhr ksdfud sdhudschsdc") else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal3 = Restaurants(name: "Amager", photo: photo3, desc: "ie gia usdhfisd fsdjhsushdusd hsjh dschsdc") else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal4 = Restaurants(name: "Crhsitrghu", photo: photo4, desc: "ie giuhr ksdfud sdhudschsdc") else {
            fatalError("Unable to instantiate meal1")
        }
        
        restaurants += [meal1, meal2, meal3, meal4]
    }

    
}

