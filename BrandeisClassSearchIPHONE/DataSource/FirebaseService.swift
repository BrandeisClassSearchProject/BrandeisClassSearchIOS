

//  A delegate for interacting with Firebase
//  An instance of this class will be stored in CourseDictionary class,
//  And funcs in CourseDictionary will call funcs in this class

import Foundation
import Firebase

class FirebaseService {
    
<<<<<<< HEAD
    //static let shared = FirebaseService()
    
    init() {
        FIRApp.configure()
    }
    
    var BASE_REF: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
=======
    static let shared = FirebaseService()
    
    var BASE_REF: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
>>>>>>> refs/remotes/Offical/master
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
        
        BASE_REF.observeSingleEvent(of: .value, with: { (snapshot) in
            for semester in snapshot.children.allObjects as! [FIRDataSnapshot] {
                print("Semester: \(semester.key)")
                for course in semester.children.allObjects as! [FIRDataSnapshot] {
                    if(course.hasChild("NAME")) {
                        let courseName: String = (course.childSnapshot(forPath: "NAME").value as! String).lowercased()
                        if courseName.range(of: courseID.lowercased()) != nil || course.key.lowercased().range(of: courseID.lowercased()) != nil {
                            matchingCourses.append(course.key)
                        }
                    }
                    
                }
            }
            
        })
        return matchingCourses
    }
    
    
    //These two function will return a dictionary(map) of course names to course id
    //and a dictionary(map) of course id to course names
    //These will be called only once in CourseDictionary initialzation
    func nameToId() -> [String:String] {
        
        var nameIdDict = [String:String]()
        
        BASE_REF.observe(.value, with: { (snapshot) in
            for semester in snapshot.children.allObjects as! [FIRDataSnapshot] {
                for data in semester.children.allObjects as! [FIRDataSnapshot] {
                    if data.hasChild("NAME") {
                        let className = data.childSnapshot(forPath: "NAME").value as! String
                        let classId = data.key
                        nameIdDict[className] = classId
                    }
                }
            }
            
        })
        
        return nameIdDict
    }
    
    func idToName() -> [String:String] {
        
        var idNameDict = [String:String]()
        
        BASE_REF.observe(.value, with: { (snapshot) in
            for semester in snapshot.children.allObjects as! [FIRDataSnapshot] {
                for data in semester.children.allObjects as! [FIRDataSnapshot] {
                    if data.hasChild("NAME") {
                        let className = data.childSnapshot(forPath: "NAME").value as! String
                        let classId = data.key
                        idNameDict[classId] = className
                    }
                }
            }
            
        })
        
        return idNameDict

    }
    
    
    
    

    
}
