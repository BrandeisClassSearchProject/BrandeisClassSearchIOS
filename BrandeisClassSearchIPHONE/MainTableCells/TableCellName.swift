//
//  TableCellName.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/12/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class TableCellName: UITableViewCell {

    
    @IBOutlet weak var courseIDlabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
