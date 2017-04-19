//
//  LocationViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 4/19/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    var locations:String = ""
    
    @IBOutlet var showLocation: UILabel!

    override func viewDidLoad() {
        showLocation.text = locations
        super.viewDidLoad()
    }
}
