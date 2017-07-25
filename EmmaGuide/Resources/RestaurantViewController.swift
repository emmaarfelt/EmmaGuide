//
//  RestaurantViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 20/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 250.0 // How much should the header move before it stops it transformation?
let offset_B_LabelHeader:CGFloat = 280.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the White Label and its position in the final header size (header height - HeaderStop).

class RestaurantViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    var headerBlurImageView:UIImageView!
    var blurredHeaderImageView:UIImageView?
    
    var restaurant:Restaurants!
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        blackLabel.text = restaurant.name
        headerLabel.text = restaurant.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Header - Image
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = restaurant.photo
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.image = restaurant.photo.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}
