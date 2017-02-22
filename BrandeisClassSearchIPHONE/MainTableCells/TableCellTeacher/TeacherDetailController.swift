//
//  TeacherDetailController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 2/16/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class TeacherDetailController: UITableViewController {
    
    var teacher: Teacher?
    var picture: Data?
    var rating: Double?
    private var numberOfRows:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let t = teacher?.contents.count{
            numberOfRows = t+3
            return t+3
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch indexPath.row {
        case 0:
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TeacherDetailCellPicture", for: indexPath) as! TeacherDetailCellPicture
            if let p = picture{
                mycell.teacherPic.image = UIImage(data:p)
            }else{
                mycell.teacherPic.image = #imageLiteral(resourceName: "unknown_person")
            }
            
            mycell.email.text = teacher?.email ?? ""
            
            mycell.office.text = teacher?.office ?? ""
            
            mycell.tel.text = teacher?.tel ?? ""
            
            return mycell
        case 1:
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TeacherDetailCellName", for: indexPath) as! TeacherDetailCellName
            mycell.name.text = teacher?.name ?? ""
            mycell.title.text = teacher?.title ?? ""
            return mycell
        case numberOfRows-1 :
            let mycell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as! TeacherDetailCellRating
            if let r = rating{
                mycell.makeStars(rating:r)
            }else{
                mycell.makeStars()
            }
            
            return mycell
        default:
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TeacherDetailCellAttribute", for: indexPath) as! TeacherDetailCellAttribute
            mycell.title.text = teacher?.getAttributeTitle(index: indexPath.row-2)
            mycell.content.text = teacher?.getAttributeContent(index: indexPath.row-2)
            return mycell
        }
        

        
    }

}
