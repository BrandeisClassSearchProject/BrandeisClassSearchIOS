//
//  TableCellTime.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/12/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class TableCellTime: UITableViewCell {

    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
