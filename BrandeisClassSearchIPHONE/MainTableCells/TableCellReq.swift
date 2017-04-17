//
//  TableCellReq.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 4/15/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class TableCellReq: UITableViewCell {

    @IBOutlet var place1: UIButton!
    
    @IBOutlet var place2: UIButton!
    
    @IBOutlet var place3: UIButton!
    
    @IBOutlet var place4: UIButton!
    
    @IBOutlet var place5: UIButton!
    
    func visualize(reqs: String){
        print("Give req string is \(reqs)")
    }
    
    func visualize(){
        print("No given reqs, Shouldnt be there, jusr remove empty ones")
    }
    

}




//<option value="CA"  title="CA School of Creative Arts Distribution Req">
//ca
//</option>
//
//<option value="FL"  title="Foreign Language Requirement">
//fl
//</option>
//
//<option value="HUM"  title="School of Humanities Distribution Requirement">
//hum
//</option>
//
//<option value="NW"  title="Non-Western and Comparative Studies Requirement">
//nw
//</option>
//
//<option value="OC"  title="Oral Communication">
//oc
//</option>
//
//<option value="PE-1"  title="Physical Education 1 Course">
//pe-1
//</option>
//
//<option value="QR"  title="QR Quantitative Reasoning Requirement">
//qr
//</option>
//
//<option value="QR1"  title="Quantitative Reasoning Lecture Course">
//qr1
//</option>
//
//<option value="SN"  title="SN School of Science Distribution Requirement">
//sn
//</option>
//
//<option value="SS"  title="SS School of Social Sci Distribution Requirement">
//ss
//</option>
//
//<option value="UWS"  title="UWS University Writing Seminar">
//uws
//</option>
//
//<option value="WI"  title="WI Writing Intensive">
//wi

