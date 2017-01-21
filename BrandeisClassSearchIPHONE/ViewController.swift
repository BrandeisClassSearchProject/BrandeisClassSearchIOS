//
//  ViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 12/21/16.
//  Copyright © 2016 Yuanze Hu. All rights reserved.
//

import UIKit
import MMDrawerController
import NVActivityIndicatorView

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    var courseDataItemStore: CourseDataItemStore?
    var courseDictionary: CourseDictionary?
    //var cells: [UITableViewCell]?
    //the sourse of dictionary for search class
    
    var isReload = false

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var centerText: UILabel!

    @IBOutlet weak var testingLongText: UITextView!
    
    override func viewDidLoad()
    {
        //
        super.viewDidLoad()
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        courseDictionary = appDel.courseDictionary!
        
        if (courseDictionary?.history!.count)! > 0 {
            let ar = courseDictionary?.search(courseID: (courseDictionary?.latestHistory())!)
            courseDataItemStore = CourseDataItemStore(searchResultArray: ar!)
            var ss = ""
            for s in ar! {
                ss  = ss + s + "\n"
            }
            print(ss)
            testingLongText.text=ss
        }else{
            var s=""
            for term in (courseDictionary?.terms)!{
                s = s+term+"\n"
            }
            testingLongText.text=s
        }
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 63.0/255.0, green: 81.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 63.0/255.0, green: 81.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
       
        isReload=true
        
    }
    
  
    //this function starts a new thread that checking if there are new cells being done
    //update the done cells, cells have benn updated are ignored next time 
    //the first three cells does not require internet, they are not updated anyway
    private func startMonitoring(staticCells : Int, timeLimitInSeconds: Double){
        self.isReload=false
        let queue = DispatchQueue(label: "Monitor")
        queue.async {
            print("Start monitoring")
            while self.courseDataItemStore == nil{}
            var updatedCells = Set<Int>()
            var counter = 0
            let limit = self.courseDataItemStore!.courseDataItemStore.count - staticCells
            let start = DispatchTime.now()
            while limit != counter {
                let timeInSeconds = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds)/1_000_000_000
                if  timeInSeconds > timeLimitInSeconds  {
                    print("Running time too long, \(timeInSeconds)!\nExit monitoring")
                    return
                }
                for i in staticCells..<self.courseDataItemStore!.courseDataItemStore.count{
                    if (self.courseDataItemStore!.courseDataItemStore[i].isDone && !(updatedCells.contains(i))){
                        updatedCells.insert(i)
                        counter += 1
                        let l = self.courseDataItemStore?.getResult(index: i)
                        if (l?.count)! < 1{
                            print("update empty")
                        }else{
                            print("update cell \(i) with:\(l?[0])")
                        }
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadRows(at: [IndexPath(row : i, section : 0)], with:.automatic)
                        }
                        print("  ***   Monitor reloads rows at \(i), which is a ( \(self.courseDataItemStore?.courseDataItemStore[i].attribute.getHeader()) )cell")
                    }
                }
            }
            print("Exit monitoring, all cells should be updated")
            
        }

    }
    
    

       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courseDataItemStore == nil {
            print("courseDataItemStore is fucking nil ?! ")
            return 0
        }else{
            print("courseDataItemStore has \(courseDataItemStore!.courseDataItemStore.count) items ")
            return courseDataItemStore!.courseDataItemStore.count
        }
    }
    
    //return and set views according to different items
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isReload {
            if indexPath.row == (courseDataItemStore?.courseDataItemStore.count)!-1 {
                startMonitoring(staticCells: 3, timeLimitInSeconds: 10)
            }
        }
        
        let a : Attribute = (courseDataItemStore?.courseDataItemStore[indexPath.row].attribute)!
        print("~Making cell at index: \(indexPath.row)  \(a.getHeader())")
        
        if a == .NAME {
            print("~setNameCell at index: \(indexPath.row)")
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellName", for: indexPath) as! TableCellName
            mycell.courseIDlabel.text = courseDictionary?.latestHistory()
            print("setNameCell courseID: \(mycell.courseIDlabel.text)")
            mycell.courseNameLabel.text = courseDataItemStore?.getResult(index: indexPath.row)[0]
            print("setNameCell courseName: \(mycell.courseNameLabel.text)")
            return mycell;
        }else if a == .BLOCK {
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellTime", for: indexPath) as! TableCellTime
            let result = courseDataItemStore?.getResult(index: indexPath.row)[0].components(separatedBy: "\n")
            if result == nil{
                return UITableViewCell()
            }else if (result?.count)! < 1 {
                return UITableViewCell()
            }
            mycell.blockLabel.text = result?[0]
            print("setBlockCell : \(mycell.blockLabel.text)")
            var temp = ""
            for i in 1..<result!.count {
                temp = temp + result![i] + "\n"
            }
            mycell.timeLabel.text = temp
            print("setBlockCell : \(temp)")
            return mycell

        }else if a == .TERM{
            print("~setTermCell at index: \(indexPath.row)")
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellYear", for: indexPath) as! TableCellYear
            mycell.yearLabel.text = "20" + (courseDataItemStore?.getResult(index: indexPath.row)[0])!
            return mycell
        }else if a == .DESCRIPTION{
            
            print("~setDesCell at index: \(indexPath.row)")
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellDescription", for: indexPath) as! TableCellDescription
            
            mycell.courseDataItem = courseDataItemStore?.courseDataItemStore[indexPath.row]
            mycell.cellPos = indexPath
            mycell.cellParent = tableView
            
            
            
            if let results = courseDataItemStore?.getResult(index: indexPath.row){
                if results.count != 0  {
                    mycell.descText.text = results[0]
                    mycell.activityIndicator.stopAnimating()
                    mycell.activityIndicator.isHidden=true
                }else{
                    mycell.activityIndicator.startAnimating()
                }
                
            }else{
                mycell.activityIndicator.startAnimating()
            }
            
            
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setDescCell(descCell: mycell)
            return mycell
            
            
        }else if a == .TEACHER{
            print("~setDesCell at index: \(indexPath.row)")
            if let l =  courseDataItemStore?.getResult(index: indexPath.row){
                if l.count >= 1 {
                    let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellTeacher", for: indexPath) as! TableCellTeacher
                    mycell.teacherName.text = l[0]
                    
                    if let tempList2 = courseDataItemStore?.courseDataItemStore[indexPath.row].resultList2 {
                        if tempList2.count > 1{ //set the degrees
                            mycell.teacherEducation.text = tempList2[1]
                            print("set teacher education  \n \( tempList2[1])")
                        }else{
                            mycell.teacherEducation.text = ""
                        }
                        if tempList2.count > 2{ //set other info
                            mycell.teacherOtherInfo.text = tempList2[2]
                        }else {
                            mycell.teacherOtherInfo.text = ""
                        }
                        
                    }
                    
                    
                    if let tempDataList = courseDataItemStore?.courseDataItemStore[indexPath.row].pictureList{
                        if tempDataList.count > 0{
                            mycell.teacherImage.image = UIImage(data: tempDataList[0])
                            print("set image of teacher")
                        }
                    }
                    print("teacher has name: \(l[0])")
                    return mycell
                }else{
                    print("the result list of teacher is empty, set spinning")
                    let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellWaiting", for: indexPath) as! TableCellWaiting
                    mycell.startAnimation()
                    return mycell
                }
            }else {
                
                let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellWaiting", for: indexPath) as! TableCellWaiting
                mycell.startAnimation()
                return mycell
                
            }
            
        }else if a == .BOOK{
            if let l =  courseDataItemStore?.getResult(index: indexPath.row){
                //print(l[0])
                if l.count >= 1 {
                    let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellBooks", for: indexPath) as! TableCellBooks
                    if let l2 = courseDataItemStore?.courseDataItemStore[indexPath.row].resultList2{
                        if l2.count == 1 {
                            mycell.bookName.text = l2[0]
                        }else if l2.count == 2 {
                            mycell.bookName.text = l2[0]+" "+l2[1]
                        }
                }else{
                    print("the result for books is nil")
                }
                return mycell
                }else{
                    let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellWaiting", for: indexPath) as! TableCellWaiting
                    mycell.startAnimation()
                    return mycell
                }
            }else {
                let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellWaiting", for: indexPath) as! TableCellWaiting
                mycell.startAnimation()
                return mycell
            }
        }else if a == .SYLLABUS{
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellSyllabus", for: indexPath)
            
            return mycell
        }else {
            print("dafuq? index:\(indexPath.row) \n \(a.getHeader())")
            return UITableViewCell ()
        }
        
    }

    
    
    
    
    

    @IBAction func LeftSideMenuOpen(_ sender: Any) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
        
    }//单击左上 打开菜单
 
    
    @IBAction func RightSideMenuOpen(_ sender: Any) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }

}


