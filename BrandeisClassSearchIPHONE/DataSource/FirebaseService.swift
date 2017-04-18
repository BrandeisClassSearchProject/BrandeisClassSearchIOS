

//  A delegate for interacting with Firebase
//  An instance of this class will be stored in CourseDictionary class,
//  And funcs in CourseDictionary will call funcs in this class

import Foundation
import Firebase

class FirebaseService {
    
    let courseDictionary: CourseDictionary
    
    //static let shared = FirebaseService()
    //input two dictionary that will be assigned
    init(courseDict: CourseDictionary) {
        FIRApp.configure()
        courseDictionary = courseDict
    }
    
    var BASE_REF: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    
    //static let shared = FirebaseService()
    
    var SEMESTER_REF: FIRDatabaseReference {
        return BASE_REF.child("1171")
    }
    
    //This function will search the lastest term in Firebase
    //If the corresponding course is found with given ID
    //return that
    //If not search the rest of terms
    //as soon as one match is found, return it
    //This function will be called by CourseDictionary.search(courseID: String)
    //the format of returned array should be ["NAME: XXXX","TIMES: XXXX"......]
    //The headers are crutial
    //All headers are listed in the Attribute enum in CourseDataItem.swift in CourseDataStructForMainList folder
    func search(courseID: String, completionHandler: @escaping ([String]) -> ()) {
        var courseData = [String]()
        var isFound = false
        
        BASE_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let semesters = snapshot.children.allObjects as! [FIRDataSnapshot]
            var semester : FIRDataSnapshot = semesters[0]
            
            for counter in 1...semesters.count {
                semester = semesters[semesters.count - counter]
                if isFound{
                    break
                }
                for course in semester.children.allObjects as! [FIRDataSnapshot] {
                    if(course.hasChild("NAME")) {
                        let courseName: String = (course.childSnapshot(forPath: "NAME").value as! String).lowercased()
                        if courseName.range(of: courseID.lowercased()) != nil || course.key.lowercased().range(of: courseID.lowercased()) != nil {
                            
                            let id = courseID.components(separatedBy: " ")
                            let currentTerm = semester.key.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                            print("Found \(courseID) in \(currentTerm)")
                            
                            //add some data
                            courseData.append("TERM:\(self.toYear(yearCode: currentTerm))")
                            courseData.append("BOOKS:http://www.bkstr.com/webapp/wcs/stores/servlet/booklookServlet?bookstore_id-1=1391&term_id-1=\(currentTerm)&div-1=&dept-1=\(id[0])&course-1=\(id[1])&sect-1=1")
                            //add some data
                            
                            for data in course.children.allObjects as! [FIRDataSnapshot] {
                                //print("DATA")
                                if(data.key == "TIMES") {
                                    var timeString = "TIMES:"
                                    for time in data.children.allObjects as! [FIRDataSnapshot] {
                                        if timeString == "TIMES:"{
                                            timeString.append("\(time.value as! String)")
                                        }else{
                                            timeString.append("#\(time.value as! String)")
                                        }
                                        
                                        
                                    }
                                    courseData.append(timeString)
                                } else {
                                    courseData.append("\(data.key): \(data.value as! String)")
                                }
                            }
                            //http://www.bkstr.com/webapp/wcs/stores/servlet/booklookServlet?bookstore_id-1=1391&term_id-1=1171&div-1=&dept-1=COSI&course-1=101A&sect-1=1
                            
                            completionHandler(courseData)
                            isFound = true
                            break
                        }
                    }
                    
                }
            }
            print("matchingCouses")
            print("Firebase Search Done")
        })
    }
    
    
    func toYear(yearCode:String) -> String {
        let code = Int(yearCode)
        var season = ""
        switch code!%10 {
        case 1:
            season = "Spring"
        case 2:
            season = "Summer"
        case 3:
            season = "Fall"
        default:
            print("Error with given year code: \(yearCode)")
            season = ""
        }
        return String((code!-1000)/10)+" "+season
        
    }
    
    //start downloading from fb
    func start(){
        print("start FirebaseService")
        nameToId()
        idToName()
        
        
    }
    
    
    //These two function will return a dictionary(map) of course names to course id
    //and a dictionary(map) of course id to course names
    //These will be called only once in CourseDictionary initialzation
    private func nameToId() {
        
        
        //var nameIdDict = [String:String]()
        
        BASE_REF.observe(.value, with: { (snapshot) in
            for semester in snapshot.children.allObjects as! [FIRDataSnapshot] {
                for data in semester.children.allObjects as! [FIRDataSnapshot] {
                    if data.hasChild("NAME") {
                        let className = data.childSnapshot(forPath: "NAME").value as! String
                        let classId = data.key
                        //print("className:\(className) --> \(classId)")
                        self.courseDictionary.fbNameToIdDic[className] = classId
                        
                    }
                }
            }
            self.courseDictionary.fbNameToIdDic["isDone"] = "T"
            print("done nameToId()")
            
        })
        
        
        //print(nameIdToDict)
        
    }
    
    private func idToName(){
        
        
        
        BASE_REF.observe(.value, with: { (snapshot) in
            for semester in snapshot.children.allObjects as! [FIRDataSnapshot] {
                for data in semester.children.allObjects as! [FIRDataSnapshot] {
                    if data.hasChild("NAME") {
                        let className = data.childSnapshot(forPath: "NAME").value as! String
                        let classId = data.key
                        //print("classId:\(classId) --> \(className)")
                        self.courseDictionary.fbIdToNameDic[classId] = className
                    }
                }
            }
            self.courseDictionary.fbIdToNameDic["isDone"] = "T"
            print("done idToName()")
            
        })
        
        
        //print(idNameDict)
        
        
    }
    
    
    
    
    
    
}
