//
//  TodayViewController.swift
//  ClassScheduleWidget
//
//  Created by Yuanze Hu on 1/26/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {//
        
    @IBOutlet var topText: UIView!
    var heightConstraint: NSLayoutConstraint?
    let p: CGFloat = 110.0

    
    override func viewDidLoad() {
     
        
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        
        print("The height is \(p)")
         heightConstraint = NSLayoutConstraint(item: topText, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: p)
        topText.addConstraint(heightConstraint!)
        // Do any additional setup after loading the view from its nib.
        
        //let CinT:CoursesInTerm = CoreDataManager().getAllSavedClassInTerms()[0]
        
        //print(CinT.term)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            print("COMPACT")
            self.view.layoutIfNeeded()// animation that op
            UIView.animate(withDuration: 0.332, animations: {
                self.heightConstraint?.constant = self.p
                self.view.layoutIfNeeded()
            })
            self.preferredContentSize = maxSize
        }
        else {
            //expanded
            print("EXPANDED")
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                self.heightConstraint?.constant = self.p*0.5
                self.view.layoutIfNeeded()
            })
            
            self.preferredContentSize = maxSize//CGSize(width: maxSize.width, height: maxSize.height)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
