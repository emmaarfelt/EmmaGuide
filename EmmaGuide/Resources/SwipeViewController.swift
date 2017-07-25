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
    
    var category: String?
    var bgColor: UIColor!
    
    var allCards: [DraggableView]!
    
    var restaurants = [Restaurants]()
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    
    override func viewDidLoad() {
        self.view.layoutIfNeeded()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadSampleMeals(category: category!)
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        loadCards()
        catName.text = category
        self.view.backgroundColor = bgColor
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
        draggableView.rest = restaurants[index]
        draggableView.name.text = restaurants[index].name
        draggableView.img.image = restaurants[index].photo
        draggableView.desc.text = restaurants[index].formatted_address
        
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
    
    
    /*private func loadSampleMeals() {
        
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
    }*/
    
    func loadSampleMeals(category: String) -> Void {
        var restaurantsIds = [String]()
        if let path = Bundle.main.path(forResource: "\(category)restaurantIDs", ofType: "txt") {
    
            let contents = try! String(contentsOfFile: path)
            let lines = contents.components(separatedBy: "\n")
            for line in lines {
                if line == "" { break }
                let nline = line.components(separatedBy: ":")[1]
                restaurantsIds.append(nline)
            }
        } else {
            print("File not found")
        }
        
        for restID in restaurantsIds {
            let restaurant = APICaller().createRestaurant(placeId: restID)
            restaurants.append(restaurant)
        }
    }

    
}

