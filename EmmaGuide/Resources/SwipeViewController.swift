//
//  ViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 10/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController, DraggableViewDelegate {

    @IBOutlet weak var backgroundView: UIView!
    
    var exampleCardLabels: [String]!
    var allCards: [DraggableView]!
    
    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290
    
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        exampleCardLabels = ["first", "second", "third", "fourth", "last"]
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
        draggableView.information.text = exampleCardLabels[index]
        draggableView.delegate = self
        return draggableView
    }
    
    func loadCards() -> Void {
        if exampleCardLabels.count > 0 {
            let numLoadedCardsCap = exampleCardLabels.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : exampleCardLabels.count
            for i in 0 ..< exampleCardLabels.count {
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
    
}

