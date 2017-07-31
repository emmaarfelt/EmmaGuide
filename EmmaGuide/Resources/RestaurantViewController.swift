//
//  RestaurantViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 20/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 250.0 // How much should the header move before it stops it transformation?
let offset_B_LabelHeader:CGFloat = 308.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the White Label and its position in the final header size (header height - HeaderStop).

class RestaurantViewController: UIViewController, UIScrollViewDelegate {
    var restaurant:Entity!
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    
    var headerBlurImageView:UIImageView!
    

    @IBOutlet var infoButtons: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    //Round bottons
    @IBOutlet var mapLocation: UIButton!
    @IBOutlet var hourButton: UIButton!
    @IBOutlet var bookButton: UIButton!
    
    
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Pin: UIImageView!
    
    @IBOutlet weak var restDesc: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        blackLabel.text = restaurant.name
        headerLabel.text = restaurant.name
        Location.text = restaurant.formatted_address
        setupLocationValues()
        restDesc.text = restaurant.comment
    }
    
    override func viewDidAppear(_ animaed: Bool) {
        var photo : UIImage
        if let pho = IMAGE_CACHE.object(forKey: restaurant.photoRef as AnyObject) {
            photo = pho
        } else {
            photo = APICaller().fetchRestaurantPhoto(photoRef: restaurant.photoRef!)!
        }
        
        // Header - Image
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = photo
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.image = photo.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
        headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            header.layer.transform = headerTransform
        }
            
        // SCROLL UP/DOWN
            
        else {
            // Header -----------
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            // Make White label move upwards
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            // Gradually Blur Image
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Move black label under header
            if offset <= offset_HeaderStop {
                if blackLabel.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
                
            }else {
                if blackLabel.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 1
                    backButton.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        header.layer.transform = headerTransform
    }
    
    @IBAction func Book(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: self.restaurant.website)!)
    }
    
    @IBAction func seeOpeningHours(_ sender: UIButton) {
        //Setup View
        let openingHoursPopUp = OpeningHoursView(frame: CGRect(x: 0, y: 0, width: 0, height: (self.view.frame.height / 2)))
        openingHoursPopUp.center = CGPoint(x: self.view.frame.size.width  / 2, y: (self.view.frame.size.height / 2) - 50)
        openingHoursPopUp.openingHours.numberOfLines = restaurant.opening_hours.count + 1
        
        openingHoursPopUp.layer.shadowRadius = 3;
        openingHoursPopUp.layer.shadowOpacity = 0.2;
        openingHoursPopUp.layer.shadowOffset = CGSize(width: 1, height: 1)
        openingHoursPopUp.layer.shadowColor = UIColor.black.cgColor
        
        //Setup Text
        openingHoursPopUp.openingHours.text = getOpeningHours(hours: restaurant.opening_hours)
        openingHoursPopUp.openingHours.sizeToFit()
        
        //Adjust width of frame
        openingHoursPopUp.frame = CGRect(x: 0, y: 0, width: openingHoursPopUp.openingHours.intrinsicContentSize.width + 50, height: (self.view.frame.height / 2))
        openingHoursPopUp.center = CGPoint(x: self.view.frame.size.width  / 2, y: (self.view.frame.size.height / 2) - 50)
        
        self.view.addSubview(openingHoursPopUp)
    }
    
    func getOpeningHours(hours : [String]) -> String {
        var allString = ""
        for hour in hours {
            allString = allString + hour + "\n"
        }
        return allString
    }
    
    @IBAction func seeOnMap(_ sender: UIButton) {
        if let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "LocationView") as? LocationController {
            
            destinationViewController.restaurant = self.restaurant!
            
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    
    
    func setupLocationValues() {
        self.Pin.frame = CGRect(x: (locationView.frame.size.width - Pin.frame.size.width - Location.intrinsicContentSize.width) / 2, y: Pin.frame.origin.y, width: Pin.frame.size.width, height: Pin.frame.size.height)
        self.Location.frame = CGRect(x: Pin.frame.origin.x + Pin.frame.size.width + 4, y: Location.frame.origin.y, width: Location.intrinsicContentSize.width, height: Location.frame.size.height)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}
