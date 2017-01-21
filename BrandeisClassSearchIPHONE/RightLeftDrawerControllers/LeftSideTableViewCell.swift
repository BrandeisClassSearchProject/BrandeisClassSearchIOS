
//  Created by Yuanze Hu on 12/25/16.


import UIKit

class LeftSideTableViewCell: UITableViewCell {

    //@IBOutlet weak var LeftSideMenuItemLabel: UIView!
    
    @IBOutlet weak var LeftSideMenuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
