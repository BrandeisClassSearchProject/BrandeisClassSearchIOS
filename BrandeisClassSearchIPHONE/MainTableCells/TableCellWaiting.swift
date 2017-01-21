//
//  TableCellWaiting.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/17/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//


import UIKit
import NVActivityIndicatorView

class TableCellWaiting: UITableViewCell {


    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    
    public func startAnimation(){
        activityIndicator.type = .squareSpin
        activityIndicator.color = UIColor(red: 250.0/255.0, green: 128.0/255.0, blue: 114.0/255.0, alpha: 1.0)//250,128,114
        activityIndicator.startAnimating()
    }
}
