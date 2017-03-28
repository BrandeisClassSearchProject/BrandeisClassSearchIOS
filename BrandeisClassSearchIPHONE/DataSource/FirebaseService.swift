

//  A delegate for interacting with Firebase
//  An instance of this class will be stored in CourseDictionary class,
//  And funcs in CourseDictionary will call funcs in this class

import Foundation
import Firebase

class FirebaseService {
    
    init(){
        //.....
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
    func search(courseID: String) -> [String]{
        //...
        return []
    }
    
    
    //These two function will return a dictionary(map) of course names to course id
    //and a dictionary(map) of course id to course names
    //These will be called only once in CourseDictionary initialzation
    func nameToId() -> [String:String] {
        //...
        return ["":""]
    }
    
    func idToName() -> [String:String] {
        //...
        return ["":""]
    }
    
    
    
    

    
}
