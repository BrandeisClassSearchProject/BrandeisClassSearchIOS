//
//  RightSideTableViewCell.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/6/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//



import UIKit

class RightSideTableViewCell: UITableViewCell {


    @IBOutlet weak var IdText: UILabel!
    @IBOutlet weak var NameText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
