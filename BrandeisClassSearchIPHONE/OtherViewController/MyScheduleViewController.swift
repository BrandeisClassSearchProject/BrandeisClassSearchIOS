//
//  MyScheduleViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 12/25/16.
//  Copyright © 2016 Yuanze Hu. All rights reserved.
//

import UIKit


class MyScheduleViewController: UIViewController {


    
    @IBOutlet var term: UILabel!
    
    var courses: CoursesInTerm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if courses != nil{
            if courses?.num != 0 {
                term.text = courses?.term
                
                
               
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
