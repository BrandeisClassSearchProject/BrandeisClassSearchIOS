//
//  TableCellDescription.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/12/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

import NVActivityIndicatorView

class TableCellDescription: UITableViewCell {

    public var cellPos : IndexPath?
    public var cellParent : UITableView?
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var descText: UITextView!
    var courseDataItem: CourseDataItem?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    
    
    
    
    
    
    

}
