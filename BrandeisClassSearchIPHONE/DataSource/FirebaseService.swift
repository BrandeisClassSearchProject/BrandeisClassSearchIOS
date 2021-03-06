

//  A delegate for interacting with Firebase
//  An instance of this class will be stored in CourseDictionary class,
//  And funcs in CourseDictionary will call funcs in this class

import Foundation
import Firebase

class FirebaseService {
    
    let courseDictionary: CourseDictionary

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
    
    func searchBySemester(semester: String, courseID: String, completionHandler: @escaping ([String]) -> ()) {
        var courseData = [String]()
        
        BASE_REF.child(semester).observeSingleEvent(of: .value, with: { (snapshot) in
                for course in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    if(course.hasChild("NAME")) {
                        let courseName: String = (course.childSnapshot(forPath: "NAME").value as! String).lowercased()
                        if courseName.range(of: courseID.lowercased()) != nil || course.key.lowercased().range(of: courseID.lowercased()) != nil {
                            
                            let id = courseID.components(separatedBy: " ")
                            //add some data
                            courseData.append("BOOKS:http://www.bkstr.com/webapp/wcs/stores/servlet/booklookServlet?bookstore_id-1=1391&term_id-1=\(semester)&div-1=&dept-1=\(id[0])&course-1=\(id[1])&sect-1=1")
                            //add some data
                            
                            for data in course.children.allObjects as! [FIRDataSnapshot] {
                                //print("DATA")
                                if(data.key == "TIMES") {
                                    var timeString = "TIMES:"
                                    for time in data.children.allObjects as! [FIRDataSnapshot] {
                                        timeString.append("\(time.value as! String)#")
                                    }
                                    courseData.append(timeString)
                                } else {
                                    courseData.append("\(data.key): \(data.value as! String)")
                                }
                            }
                            //http://www.bkstr.com/webapp/wcs/stores/servlet/booklookServlet?bookstore_id-1=1391&term_id-1=1171&div-1=&dept-1=COSI&course-1=101A&sect-1=1
                            
                            completionHandler(courseData)
                            break
                        }
                    }
                }
            print("Firebase Search by Semester Done")
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
                let semesterString = semester.key
                for data in semester.children.allObjects as! [FIRDataSnapshot] {
                    if data.hasChild("NAME") {
                        let className = data.childSnapshot(forPath: "NAME").value as! String
                        let classId = data.key
                        //print("className:\(className) --> \(classId)")
                        self.courseDictionary.fbNameToIdDic[className] = classId
                        if self.courseDictionary.fbNameToIdDicsWithYear[semesterString] != nil{
                            self.courseDictionary.fbNameToIdDicsWithYear[semesterString]![className] = classId
                        }else{
                            self.courseDictionary.fbNameToIdDicsWithYear[semesterString] = [:]
                            self.courseDictionary.fbNameToIdDicsWithYear[semesterString]![className] = classId
                        }
                    }
                }
            }
            self.courseDictionary.fbNameToIdDicsWithYear["isDone"]![""] = "T"
            self.courseDictionary.fbNameToIdDic["isDone"] = "T"
            print("done nameToId()\nfbIdToNameDicsWithYear.keys:")
            print(self.courseDictionary.fbNameToIdDicsWithYear.keys)
            print("print 1172 classes nametoid")
            print(self.courseDictionary.fbNameToIdDicsWithYear["1172"] ?? "Nothing there ???!!!")
            print("done nameToId()")
            
        })
        
        
        //print(nameIdToDict)
        
    }
    
    private func idToName(){
        BASE_REF.observe(.value, with: { (snapshot) in
            for semester in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let semesterString = semester.key
                for data in semester.children.allObjects as! [FIRDataSnapshot] {
                    if data.hasChild("NAME") {
                        let className = data.childSnapshot(forPath: "NAME").value as! String
                        let classId = data.key
                        //print("classId:\(classId) --> \(className)")
                        self.courseDictionary.fbIdToNameDic[classId] = className
                        if self.courseDictionary.fbIdToNameDicsWithYear[semesterString] != nil{
                            self.courseDictionary.fbIdToNameDicsWithYear[semesterString]![classId] = className
                        }else{
                            self.courseDictionary.fbIdToNameDicsWithYear[semesterString] = [:]
                            self.courseDictionary.fbIdToNameDicsWithYear[semesterString]![classId] = className
                        }
                    }
                }
            }
            self.courseDictionary.fbIdToNameDicsWithYear["isDone"]![""] = "T"
            self.courseDictionary.fbIdToNameDic["isDone"] = "T"
            print("done idToName()\nfbIdToNameDicsWithYear.keys:\n")
            print(self.courseDictionary.fbIdToNameDicsWithYear.keys)
            print(self.courseDictionary.fbIdToNameDicsWithYear["1171"] ?? "Nothing there ???!!!")
            print("done idToName()")
        })
    }
    
    
    
    
}
