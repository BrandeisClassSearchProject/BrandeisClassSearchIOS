//
//  TableCellTeacher.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/12/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class TableCellTeacher: UITableViewCell {

    @IBOutlet weak var teacherImage: UIImageView!
    
    @IBOutlet weak var teacherName: UILabel!

    @IBOutlet weak var teacherEducation: UILabel!
    
    @IBOutlet weak var teacherOtherInfo: UILabel!
    
   
    
    var cellPos : Int?
    var cellParent : UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
