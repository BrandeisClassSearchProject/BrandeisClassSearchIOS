//
//  MyClassesViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/28/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class MyClassesViewController: UITableViewController {
    
    class CoursesInTerms{
        
        var courseInTerms : [CoursesInTerm]
        
        init(CourseInTerms: [CoursesInTerm]) {
            courseInTerms = CourseInTerms
        }
        
        func printCoursesInTerms(){
            print("Print all coursesInTerms")
            for ct in courseInTerms{
                print("---")
                print("Term:\(ct.term)")
                print("Num:\(ct.num)")
                for c in ct.courses{
                    print(c.courseID)
                    print(c.courseName)
                    print(c.Time)
                }
                print("---")
            }
        }
        
        func count() -> Int{
            var count = 0
            for ct in courseInTerms{
                count += ct.num
            }
            return count
        }
        
        func get(index : Int) -> Course{
            var i = index
            for c in courseInTerms{
                if i < c.num {
                    if i==0{
                        return Course(courseID: "header",courseName: "header",Time: "20"+c.term)
                    }else{
                        return c.courses[i-1]
                    }
                }else{
                    i = i - c.num
                }
            }
            return Course(courseID: "",courseName: "",Time: "")
        }
        
        func canEdit(index : Int) -> Bool {
            var i = index
            for c in courseInTerms{
                if i < c.num {
                    if i==0{
                        return false
                    }else{
                        return true
                    }
                }else{
                    i = i - c.num
                }
            }
            return false
        }
        
        func remove(index : Int) {
            var i = index
            var j = 0
            for c in courseInTerms{
                if i < c.num {
                    if i==0{
                        print("cannot remove header")
                        return
                    }else{
                        courseInTerms[j].num = courseInTerms[j].num - 1
                        courseInTerms[j].courses.remove(at: i-1)
                        print("remove course at \(j) at \(i-1)")
                        return
                    }
                }else{
                    i = i - c.num
                }
                j = j+1
            }
        }
        
        
    }
    
    var cInTerms = CoursesInTerms(CourseInTerms: (UIApplication.shared.delegate as! AppDelegate).getAllSavedClassInTerms() )
    
    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var myCourses = (UIApplication.shared.delegate as! AppDelegate).getAllSavedClassObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let button = self.editButtonItem
        
        button.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = button
        
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cInTerms.count()
        //return myCourses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //with header
        let course = cInTerms.get(index: indexPath.row)
        if course.courseID == "" {
            return UITableViewCell()
        }
        if course.courseID == "header" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyClassesCellHeader", for: indexPath) as! MyClassesCellHeader
            cell.year.text = course.Time
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyClassesCell", for: indexPath) as! MyClassesCell
            //let attributes = ["courseID","courseName","courseTime","courseYear"]
            cell.courseID.text = course.courseID
            cell.courseName.text = course.courseName
            cell.courseTime.text = course.Time
            return cell
        }
        //with header
        
        
//        //without header
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyClassesCell", for: indexPath) as! MyClassesCell
//        //let attributes = ["courseID","courseName","courseTime","courseYear"]
//        if let classid = myCourses[indexPath.row].value(forKey: "courseID") as? String{
//            cell.courseID.text = classid
//        }
//        if let coursename = myCourses[indexPath.row].value(forKey: "courseName") as? String{
//            cell.courseName.text = coursename
//        }
//        if let courseyear = myCourses[indexPath.row].value(forKey: "courseYear") as? String{
//            cell.courseYear.text = courseyear
//        }
//        if let coursetime = myCourses[indexPath.row].value(forKey: "courseTime") as? String{
//            cell.courseTime.text = coursetime
//        }
//        return cell
//        //without header
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return cInTerms.canEdit(index: indexPath.row)
        //return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            print("try to delete")
//            //without header
//            appDel.deleteCourse(index: indexPath.row)
//            myCourses.remove(at: indexPath.row)
//            //without header
            
            //with header
            appDel.deleteCourse(courseID: cInTerms.get(index: indexPath.row).courseID)
            cInTerms.remove(index: indexPath.row)
            //with header
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //with header
        let classid = cInTerms.get(index: indexPath.row).courseID
        if classid == "header" {
            return
        }
        
        
        appDel.addHistory(newHistory: classid)
        let myVC = storyboard?.instantiateViewController(withIdentifier: "center") as! ViewController
        myVC.isFromMyClasses = true
        navigationController?.pushViewController(myVC, animated: true)
        
        return
        //with header
    
        
//        if let classid = myCourses[indexPath.row].value(forKey: "courseID") as? String{
//            appDel.addHistory(newHistory: classid)
//            let myVC = storyboard?.instantiateViewController(withIdentifier: "center") as! ViewController
//            myVC.isFromMyClasses = true
//            navigationController?.pushViewController(myVC, animated: true)
//            
//            return
//        }
//        print("switch to ViewController not successful")
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
