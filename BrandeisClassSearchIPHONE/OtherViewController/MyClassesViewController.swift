//
//  MyClassesViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/28/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

class MyClassesViewController: UITableViewController {
    
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
        return myCourses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyClassesCell", for: indexPath) as! MyClassesCell
        //let attributes = ["courseID","courseName","courseTime","courseYear"]
        if let classid = myCourses[indexPath.row].value(forKey: "courseID") as? String{
            cell.courseID.text = classid
        }
        if let coursename = myCourses[indexPath.row].value(forKey: "courseName") as? String{
            cell.courseName.text = coursename
        }
        if let courseyear = myCourses[indexPath.row].value(forKey: "courseYear") as? String{
            cell.courseYear.text = courseyear
        }
        if let coursetime = myCourses[indexPath.row].value(forKey: "courseTime") as? String{
            cell.courseTime.text = coursetime
        }
        
        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            print("try to delete")
            appDel.deleteCourse(index: indexPath.row)
            myCourses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let classid = myCourses[indexPath.row].value(forKey: "courseID") as? String{
            appDel.addHistory(newHistory: classid)
            let myVC = storyboard?.instantiateViewController(withIdentifier: "center") as! ViewController
            myVC.isFromMyClasses = true
            navigationController?.pushViewController(myVC, animated: true)
            
            return
        }
        print("switch to ViewController not successful")
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
