//
//  TeacherDetailCellRating.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 2/22/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class TeacherDetailCellRating: UITableViewCell {

    
    @IBOutlet var s1: UIImageView!
    
    @IBOutlet var s2: UIImageView!

    @IBOutlet var s3: UIImageView!
    
    @IBOutlet var s4: UIImageView!
    
    @IBOutlet var s5: UIImageView!
    
    var stars:[UIImageView]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stars = [s1,s2,s3,s4,s5]
        
    }
    
    func makeStars(){
        if let ss = stars{
            for s in ss{
                s.image = #imageLiteral(resourceName: "star_loading")
            }
        }
    }
    
    func makeStars(rating: Double) {
        
    }

    
    
}
