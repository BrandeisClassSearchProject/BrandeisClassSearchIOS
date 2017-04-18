//
//  MyScheduleViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 12/25/16.
//  Copyright © 2016 Yuanze Hu. All rights reserved.
//

import UIKit


class MyScheduleViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var column0: UIStackView!

    @IBOutlet var mon: UIStackView!
    
    @IBOutlet var tue: UIStackView!
    
    @IBOutlet var wed: UIStackView!
    
    @IBOutlet var thur: UIStackView!
    
    @IBOutlet var fri: UIStackView!
    
    @IBOutlet var term: UILabel!
    
    @IBOutlet var legendTable: UITableView!
    
    var courses: CoursesInTerm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        legendTable.rowHeight = UITableViewAutomaticDimension
        legendTable.estimatedRowHeight = 30
        if courses != nil{
            if courses?.num != 0 {
                if let t = courses?.term{
                    term.text = "20\(t)"
                }

//                let v = column0.viewWithTag(1)
//                v?.backgroundColor = UIColor.brown
                
                var i = 0
                for c in (courses?.courses)!{//for each course, draw schedule with color from getColor call
                    print("time input: \(c.Time)")
                    paint(time: c.Time, color: Colors.getColor(index: i))
                    i = i + 1
                }

                
                for c in (courses?.courses)!{
                    print(c.courseID)
                    print(c.courseName)
                    print(c.Time)
                }
                
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCell(withIdentifier: "legendCell", for: indexPath) as! MyScheduleTableViewCell
        if let cs = courses {
            mycell.classLabel.text = cs.courses[indexPath.row].courseID + " | " + cs.courses[indexPath.row].courseName
            mycell.colorView.backgroundColor = Colors.getColor(index: indexPath.row)
        }
        return mycell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cs = courses {
            return cs.courses.count
        }else {
            return 0
        }
        
    }
    
    
    
    
    
    struct oneDaySchedule {
        let day: String
        let timeTags: [Int]
    }
    
    //the method that does all the jobs
    //it colors one course's schedule with given color
    //do nothing if the give time string is not valid
    func paint(time: String, color: UIColor){
        var i = 0
        for s in getDaySchedule(time: time){
            paint(schedule: s, color: color)
            i += 1
        }
    }
    
    //draw for one single day
    //draw nothing if the timeTags array is empty
    private func paint(schedule: oneDaySchedule, color: UIColor){
        switch schedule.day {
        case "M":
            doPaint(stackView: mon, tags: schedule.timeTags, color: color)
            return
        case "T":
            doPaint(stackView: tue, tags: schedule.timeTags, color: color)
            return
        case "W":
            doPaint(stackView: wed, tags: schedule.timeTags, color: color)
            return
        case "Th":
            doPaint(stackView: thur, tags: schedule.timeTags, color: color)
            return
        case "F":
            doPaint(stackView: fri, tags: schedule.timeTags, color: color)
            return
        default:
            print("ERROR: the schedule.day is not one of M to F. schedule.day == \(schedule.day)")
            return
        }
        
    }
    
    private func doPaint(stackView: UIStackView, tags: [Int], color: UIColor){
        for tag in tags {
            if let block = stackView.viewWithTag(1)?.viewWithTag(tag){
                block.backgroundColor = color
            }else{
                print("The tags cannot be found, tag == \(tag)")
            }
        }
    }
    
    //convert the given string to the data structure oneDaySchedule 
    //put each day schedule into an array
    //return [] if the given input is not valid
    private func getDaySchedule(time: String) ->  [oneDaySchedule]{
        var daysSchedule: [oneDaySchedule] = []
        let a = time.components(separatedBy: "\n")
        //let a = time.components(separatedBy: "  ")
//        if a.count < 2 {
//            print("ERROR: the input time string does not have at least 2 lines, a.count==\(a.count), time: String == \(time)")
//            return daysSchedule
//        }
        for i in 0...a.count-1{
            let dayAndtime = a[i].components(separatedBy: "  ")//the first is eg T,Th. The second is eg 3:30 PM - 4:50 PM
            if dayAndtime.count < 2 {
                print("ERROR: failed to separted day and time, a[i]==\(a[i])")
            }else{
                let days = dayAndtime[0].components(separatedBy: ",")
                if days.count < 1 {
                    print("ERROR: the number of days is less than 1, which does not make sense, when separted by (,), dayAndtime[0]==\(dayAndtime[0])")
                }else{
                    for d in days {
                        daysSchedule.append(oneDaySchedule(day:d, timeTags: getTags(time: dayAndtime[1])))
                    }
                }
            }
        }
        return daysSchedule
    }
    
    //convert the given string to an array of tags corresponding to the ones on the storyboard
    //return [] if the given string is not valid
    private func getTags(time: String) -> [Int]{
        var tags:[Int] = []
        let timeInterval = time.components(separatedBy: " – ")
        if timeInterval.count != 2 {
            print("ERROR: the timeInterval length is not 2 in getTags(time: \(time))")
            return tags
        }
        var start = toTag(time: timeInterval[0])
        let end = toTag(time: timeInterval[1])
        if start == 0 || end == 0 {
            print("ERROR: the toTag method returns 0. start:\(timeInterval[0]), end:\(timeInterval[1])")
            return tags
        }
        while start < end {
            tags.append(start)
            if start % 100 == 30 {
                start += 70
            }else {
                start += 30
            }
        }
        return tags
    }
    
    private func toTag(time: String) -> Int{
        let temp = time.components(separatedBy: " ")
        if temp.count != 2 {//if the format is wrong for some reason, return 0
            print("ERROR: when sepratedBy an empty space in the toTag(time: \(time)). ")
            return 0
        }
        let num = temp[0].components(separatedBy: ":")
        if num.count != 2 {//if the format is wrong for some reason, return 0
            print("ERROR: when seprated the string temp[1] (\(temp[1])), by : in the toTag(time: \(time)).  ")
            return 0
        }
        let timeInInt = Int(num[0])! * 100 + Int(num[1])!
        if num[0] != "12" && temp[1] == "PM" {
            return timeInInt + 1200
        }else {
            return timeInInt
        }
    }
    
    

}
