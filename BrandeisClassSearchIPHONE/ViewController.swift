//
//  ViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 12/21/16.
//  Copyright © 2016 Yuanze Hu. All rights reserved.
//  http://registrar-prod.unet.brandeis.edu/export/export.json

import UIKit
import MMDrawerController
import NVActivityIndicatorView
import KCFloatingActionButton

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    //MARK: - variables
    var courseDataItemStore: CourseDataItemStore?
    
    var courseDictionary: CourseDictionary?
    //the sourse of dictionary for search class
    
    var isReload = false //set to true during viewDidLoad, and set false when reload starts
    
    let isLocal = false//set manully to decide if we want to fetch data from firebase or local file
    
    var isFromMyClasses = false //different actions need to be taken if it is from clicking an 
                                //existing course in MyClasses

    @IBOutlet weak var tableView: UITableView!
    
    
    var leftBut: UIButton?
    var isRot = false //if the button is rotated

    
    
    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate //instance of AppDelegate for reusing

    
    //MARK: - view Did Load
    override func viewDidLoad()
    {
        //
        super.viewDidLoad()
        courseDictionary = appDel.courseDictionary!
        
        if (courseDictionary?.history!.count)! > 0 {
            //Test fb
            courseDictionary?.search(courseID: (courseDictionary?.latestHistory())!, completionHandler: searchCompletion(searchResult: ))
            
        }else{
            print("empty main table")
        }
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 63.0/255.0, green: 81.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 63.0/255.0, green: 81.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        if courseDataItemStore == nil{
            isReload=false
            //if the courseDataItemStore is empty, do nothing
        }else{
            isReload=true
        }
        let but = self.navigationController?.navigationBar
        
        but?.tintColor = UIColor.white
       
        if isFromMyClasses {

            

        }else{
            
            //MARK: right button
            let rightBut = UIButton(type: .custom)
            rightBut.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            rightBut.addTarget(self, action: #selector(ViewController.RightSideMenuOpen), for: .touchUpInside)
            rightBut.setImage(#imageLiteral(resourceName: "search"), for: .normal)
            //rightBut.tintColor = UIColor.white
            self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: rightBut)], animated: false)
            
            
            self.title = "Brandeis Class Search"
            
            //MARK: left button
            self.leftBut = UIButton(type: .custom)
            self.leftBut?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            self.leftBut?.addTarget(self, action: #selector(ViewController.LeftSideMenuOpen), for: .touchUpInside)
            self.leftBut?.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
            
            self.navigationItem.setLeftBarButtonItems([UIBarButtonItem(customView: leftBut!)], animated: false)
            
            
            
            //MARK: fab button setting
            let fab = KCFloatingActionButton()
            fab.buttonColor = UIColor(red: 255.0/255.0, green: 64.0/255.0, blue: 129.0/255.0, alpha: 1.0)
            fab.plusColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            fab.addItem("SAVE", icon: UIImage( named: "save_icon")!, handler: { item in
                
                //            if self.courseDataItemStore == nil {
                //
                //                let alert = UIAlertController(title: "nothing there...", message: "Click too-right corner to search for a class first~", preferredStyle: .alert)
                //                self.present(alert, animated: true, completion: nil)
                //                fab.close()
                //
                //                return
                //            }
                
                
                
                let alert = UIAlertController(title: "Save class", message: "Save this class?", preferredStyle: .alert)
                
                let yesOption = UIAlertAction(title: "Yes", style: .default, handler: self.saveHandler)
                
                
                
                let noOption = UIAlertAction(title: "Not yet", style: .default, handler: self.notSaveHandler)
                
                alert.addAction(noOption)
                
                alert.addAction(yesOption)//save the course here
                
                
                
                
                self.present(alert, animated: true, completion: nil)
                fab.close()
                
                
            })
            self.view.addSubview(fab)
            
            
        }
        
        
        
        
    }
    
 
    
    
    
    
    func searchCompletion(searchResult:[String]){
        print(searchResult)
        
        let courseDataItemStoreTemp = CourseDataItemStore(searchResultArray: searchResult)
        
        
        print("courseDataItemStoreTemp:")
        courseDataItemStoreTemp.summary();
        print("\ncourseDataItemStore:")
        courseDataItemStore?.summary()
        if !isLocal{
            isReload = true
            //enable the reloading
            courseDataItemStore = courseDataItemStoreTemp
            tableView.reloadData()
        }
        
        
    }
    
    //MARK: - fab button handling
    func saveHandler(_: UIAlertAction!) {
        if courseDataItemStore != nil{
            if courseDataItemStore?.courseDataItemStore.count != 0 {
                
                var tempTime = ""
                let timeArray = (courseDataItemStore?.getResult(index: 2)[0])!.components(separatedBy: "#")
                for t in timeArray {
                    if t != ""{
                        let tArray = t.components(separatedBy: "\n")
                        if tempTime == ""{
                            tempTime = tArray[0]+"\n"+tArray[2]
                        }else{
                            tempTime.append("\n\(tArray[1])")
                        }
                    }
                }
                
                appDel.setSavedCourse(
                    courseID: (courseDictionary?.latestHistory())!, courseName: (courseDataItemStore?.getResult(index: 0)[0])!, courseYear: (courseDataItemStore?.getResult(index: 1)[0])!, courseTime: tempTime)
            }else{
                print("the courseDataItemStore is empty, nothing can be saved")
            }
        }else{
            print("the courseDataItemStore is nil, nothing can be saved")
        }
    }
    
    func notSaveHandler (_: UIAlertAction!){
        for s in appDel.getAllSavedClass(){
            print("   \(s)")
        }
    }
    
    
    
    
  
    //this function starts a new thread that checking if there are new cells being done
    //update the done cells, cells have benn updated are ignored next time 
    //the first three cells does not require internet, they are not updated anyway
    //MARK: - Monitoring Thread
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
    
    //MARK: - TableView functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let a = courseDataItemStore?.courseDataItemStore[indexPath.row].attribute {
            
            switch a{
            case .BOOK:
                if (courseDataItemStore?.getResult(index: indexPath.row).isEmpty)!{
                    return
                }
                if (courseDataItemStore?.getResult(index: indexPath.row)[0] == "no textbooks information"){
                    return
                }
                print("Switch to BooksTableView")
                let myVC = storyboard?.instantiateViewController(withIdentifier: "BooksTableView") as!BooksTableViewController
                myVC.resultList = courseDataItemStore?.getResult(index: indexPath.row)
                navigationController?.pushViewController(myVC, animated: true)
                break
            case .BLOCK:
                if let cdis = courseDataItemStore{
                    if (cdis.getResult(index: indexPath.row).isEmpty){
                        return
                    }
                    
                    let myVC = storyboard?.instantiateViewController(withIdentifier: "MySchedule") as! MyScheduleViewController
                    
                    if let a = courseDictionary?.latestHistory() {
                        var tempTime = ""
                        let timeArray = cdis.getResult(index: indexPath.row)[0].components(separatedBy: "#")
                        for t in timeArray {
                            if t != ""{
                                let tArray = t.components(separatedBy: "\n")
                                if tempTime == ""{
                                    tempTime = tArray[2]
                                }else{
                                    tempTime.append("\n\(tArray[1])")
                                }
                            }
                        }
                        //cdis.getResult(index: indexPath.row)[0]
                        myVC.courses = CoursesInTerm(num: 1, term: cdis.getResult(index: 1)[0], courses: [Course(courseID: a,courseName: cdis.getResult(index: 0)[0],Time: tempTime)])
                        navigationController?.pushViewController(myVC, animated: true)
                    }
                }
                
                break
            case .TEACHER:
                if let teacher = courseDataItemStore?.courseDataItemStore[indexPath.row].teacher{
                    let myVC = storyboard?.instantiateViewController(withIdentifier: "TeacherDetailController") as! TeacherDetailController
                    myVC.teacher = teacher
                    navigationController?.pushViewController(myVC, animated: true)
                }else{
                    print("ERROR")
                }
                break
            case .LOCATION:
                
                let myVC = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
                
                if let loc = (courseDataItemStore?.courseDataItemStore[indexPath.row].rawInput){
                    //myVC.showLocation.text = loc
                    myVC.locations = loc
                    navigationController?.pushViewController(myVC, animated: true)
                }
                
                break
            default:
                print(" Not implemented yet......=>\(a.getHeader())")
            }
            
        }
        
        
        
        
    }
    
    //standard, get number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courseDataItemStore == nil {
            //print("courseDataItemStore is fucking nil ?! ")
            return 0
        }else{
            print("courseDataItemStore has \(courseDataItemStore!.courseDataItemStore.count) items ")
            return courseDataItemStore!.courseDataItemStore.count
        }
    }
    
    //return and set views according to different items
    //need reforming in the future 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: Cell For Row At
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
            //print("setNameCell courseID: \(mycell.courseIDlabel.text)")
            mycell.courseNameLabel.text = courseDataItemStore?.getResult(index: indexPath.row)[0]
            if let sec = courseDataItemStore?.section {
                if sec != "1" && sec != "" {
                    mycell.section.text = "section: "+sec
                }else{
                    mycell.section.text = ""
                }
            }
            //print("setNameCell courseName: \(mycell.courseNameLabel.text)")
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
            //print("setBlockCell : \(mycell.blockLabel.text)")
            var temp = ""
            for i in 1..<result!.count {
                if i == result!.count-1 {
                    temp = temp + result![i]
                }else{
                    temp = temp + result![i] + "\n"
                }
            }
            
            
            mycell.timeLabel.text = temp.replacingOccurrences(of: "#", with: "\n")
            
            
            return mycell

        }else if a == .TERM{
            print("~setTermCell at index: \(indexPath.row)")
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellYear", for: indexPath) as! TableCellYear
            mycell.yearLabel.text = "20" + (courseDataItemStore?.getResult(index: indexPath.row)[0])!
            if courseDataItemStore?.code == ""{
                mycell.code.text = ""
            }else{
                mycell.code.text = "Code: "+(courseDataItemStore?.code)!

            }
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
        }else if a == .LOCATION{
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellLoc", for: indexPath) as! TableCellLocation
            if let loc = (courseDataItemStore?.courseDataItemStore[indexPath.row].rawInput){
                mycell.location.text = loc
            }else{
                mycell.location.text = "TBD"
            }
            return mycell
        }else if a == .REQ{
            let mycell = tableView.dequeueReusableCell(withIdentifier: "TableCellReq", for: indexPath) as! TableCellReq
            if let req = (courseDataItemStore?.courseDataItemStore[indexPath.row].rawInput){
                mycell.visualize(reqs: req)
            }
            return mycell
        }else {
            print("dafuq? index:\(indexPath.row) \n \(a.getHeader())")
            return UITableViewCell ()
        }
        
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        print("present present")
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        super .viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        super .viewWillDisappear(animated)
    }
    
    //MARK: - Open Menus
    
    public func rotateLeftButton(){
    
        UIView.animate(withDuration: 0.3) {
            if self.isRot{
                self.isRot = false
                self.leftBut?.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            }else{
                self.isRot = true
                self.leftBut?.transform = CGAffineTransform(rotationAngle: CGFloat(-.pi / 2.0))
            }
        }
    }

    func LeftSideMenuOpen() {
        print("left but clicked")
        rotateLeftButton()
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
        
    }//click to open menu
 
    
    func RightSideMenuOpen() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }

}



