

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
    //the format of returned array should be ["NAME: XXXX","TIME: XXXX"......]
    //The headers are crutial
    //All headers are listed in the Attribute enum in CourseDataItem.swift in CourseDataStructForMainList folder
    func search(courseID: String) -> [String]{
        
        var matchingCourses = [String]()
        //var isDone = false
        BASE_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            for semester in snapshot.children.allObjects as! [FIRDataSnapshot] {
                print("Semester: \(semester.key)")
                for course in semester.children.allObjects as! [FIRDataSnapshot] {
                    if(course.hasChild("NAME")) {
                        let courseName: String = (course.childSnapshot(forPath: "NAME").value as! String).lowercased()
                        if courseName.range(of: courseID.lowercased()) != nil || course.key.lowercased().range(of: courseID.lowercased()) != nil {
                            matchingCourses.append(course.key)
                            print(course.childSnapshot(forPath: "TIME"))
                            
                            
                        }
                    }
                    
                }
            }
            print("matchingCouses")
            print(matchingCourses)
            print("Firebase Search Done")
            //isDone = true
            
        })
        
        //while !isDone{}
                return matchingCourses
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
