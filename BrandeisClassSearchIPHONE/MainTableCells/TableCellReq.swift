//
//  TableCellReq.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 4/15/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit
struct req {
    let name: String;
    let title: String;
    let color: UIColor;
}

extension UIColor{
    public convenience init(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    public convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }

}


class TableCellReq: UITableViewCell {
    


    let reqDictionary = [
        "ca":req(name: "ca",title: "Creative Arts Requirement",color: UIColor(r:133,g:139,b:235)),
        "fl":req(name: "fl",title: "Foreign Language Requirement",color: UIColor(r:88,g:134,b:74)),
        "hum":req(name: "hum",title: "Humanities Requirement",color: UIColor(r:241,g:158,b:154)),
        "nw":req(name: "nw",title: "Non-Western and Comparative Studies Requirement",color: UIColor(r:238,g:99,b:98)),
        "oc":req(name: "oc",title: "Oral Communication Requirement",color: UIColor(r:233,g:225,b:95)),
        "pe-1":req(name: "pe",title: "Physical Education Requirement",color: UIColor(r:231,g:128,b:60)),
        "pe":req(name: "pe",title: "Physical Education Requirement",color: UIColor(r:231,g:128,b:60)),
        "qr":req(name: "qr",title: "Quantitative Reasoning Requirement",color: UIColor(r:41,g:96,b:158)),
        "qr1":req(name: "qr1",title: "Quantitative Reasoning Lecture",color: UIColor(r:44,g:105,b:172)),
        "sn":req(name: "sn",title: "School of Science Requirement",color: UIColor(r:41,g:68,b:116)),
        "ss":req(name: "ss",title: "School of Social Science Requirement",color: UIColor(r:65,g:145,b:152)),
        "uws":req(name: "uws",title: "University Writing Seminar",color: UIColor(r:25,g:25,b:25)),
        "wi":req(name: "wi",title: "Writing Intensive",color: UIColor(r:164,g:58,b:64))]

    @IBOutlet var reqText: UILabel!
    
    @IBOutlet var place1: UIButton!
    
    @IBOutlet var place2: UIButton!
    
    @IBOutlet var place3: UIButton!
    
    @IBOutlet var place4: UIButton!
    
    @IBOutlet var place5: UIButton!
    
    var numberOfReq = -1
    
    
    func visualize(reqs: String){
        let butList = [place1,place2,place3,place4,place5]
        print("Given req string is \(reqs)")
        let reqList = reqs.components(separatedBy: " ")
        var i = 0
        for r in reqList{
            if let s = reqDictionary[r]{
                butList[i]?.layer.cornerRadius = 5
                butList[i]?.backgroundColor = s.color
                butList[i]?.setTitle(s.name, for: .normal)
                i += 1
            }
        }
        numberOfReq = reqList.count
        if reqList.count == 1{
            reqText.text = reqDictionary[reqList[0]]?.title
            //reqText.textColor = reqDictionary[reqList[0]]?.color
        }else{
            reqText.text = "\(String(reqList.count)) requirements fullfilled "
        }
        
        
    }
    
    func visualize(){
        print("No given reqs, Shouldnt be there, jusr remove empty ones")
    }
    
    
   
    
    
    
    @IBAction func showDetail(_ sender: Any) {
        if numberOfReq != 1{
            let b = sender as! UIButton
            
            UIView.animate(withDuration: 0.1, animations: {
                self.reqText.alpha = 0
                self.superview?.layoutIfNeeded()
            }, completion: { (true) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.reqText.text = self.reqDictionary[(b.titleLabel?.text)!]?.title
                    self.reqText.textColor = self.reqDictionary[(b.titleLabel?.text)!]?.color
                    self.reqText.alpha = 1
                    self.superview?.layoutIfNeeded()
                })
            })
            
            
        }
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

