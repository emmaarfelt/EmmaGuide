//
//  InitialViewController.swift
//  EmmaGuide
//
//  Created by Emma Arfelt Kock on 31/07/2017.
//  Copyright © 2017 Emma Arfelt. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBAction func viewCategories(_ sender: UIButton) {
        guard let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "ViewCategories") else { return }
         navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
