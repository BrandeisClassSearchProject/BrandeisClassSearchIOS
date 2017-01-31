//
//  BooksAmazonPageController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/31/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class BooksAmazonPageController: UIViewController {
    
    var IBSN: String?
    
    @IBOutlet weak var webView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ibsn = IBSN {
            self.navigationController?.navigationBar.isTranslucent = false
            
            let amazonUrl = "https://www.amazon.com/gp/search/ref=sr_adv_b/?search-alias=stripbooks&unfiltered=1&field-keywords=&field-author=&field-title=&field-isbn=\(ibsn)&field-publisher=&node=&field-p_n_condition-type=&p_n_feature_browse-bin=&field-age_range=&field-language=&field-dateop=During&field-datemod=&field-dateyear=&sort=relevanceexprank&Adv-Srch-Books-Submit.x=0&Adv-Srch-Books-Submit.y=0"
            webView.loadRequest(NSURLRequest(url: NSURL(string: amazonUrl)! as URL) as URLRequest)
            
        }else{
            print("ERROR: The ibsn does not exist")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



//"https://www.amazon.com/gp/search/ref=sr_adv_b/?search-alias=stripbooks&unfiltered=1&field-keywords=&field-author=&field-title=&field-isbn=9781780325941&field-publisher=&node=&field-p_n_condition-type=&p_n_feature_browse-bin=&field-age_range=&field-language=&field-dateop=During&field-datemod=&field-dateyear=&sort=relevanceexprank&Adv-Srch-Books-Submit.x=0&Adv-Srch-Books-Submit.y=0"
