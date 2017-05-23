//
//  CourseDictionary.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 12/29/16.
//  Copyright © 2016 Yuanze Hu. All rights reserved.
//  a interface to modify and perform database functions
//  the ViewController.swift holds an instance of this
//
//  this class will handle all the searching action




import Foundation


class IdNameTwoSideDictionary {
    public var nameToId : [String:String]
    public var idToName : [String:String]
    var isDone = false
    
    convenience init() {
        self.init(nameToId : [:], idToName : [:])
    }
            
    init(nameToId : [String:String], idToName : [String:String]){
        self.idToName = idToName
        self.nameToId = nameToId
    }
    
    func append(id:String,name:String){
        nameToId[name] = id
        idToName[id] = name
    }
    
    func get(id:String) -> String?{
        return idToName[id]
    }
    
    func get(name:String) -> String?{
        return nameToId[name]
    }
}

class SemesterIdNameTwoSideDictionary{
    private var semesterIdNameTwoSideDictionary: [String:IdNameTwoSideDictionary]
    private var semesters : [String]
    
    init() {
        semesterIdNameTwoSideDictionary = [:]
        semesters = []
    }
    
    func append(semester:String, twoSideDictionary: IdNameTwoSideDictionary){
        semesters.append(semester)
        semesterIdNameTwoSideDictionary[semester] = twoSideDictionary
    }
    
    func suggestion(fixedID: String, suggestionLength: Int) -> Suggestions{
        var tempSuggestion = Suggestions(suggestions: [:], terms: [])
        var temp:[IdNamePair] = []
        var i = 0
        
        for semester in semesters.reversed(){
            if let twoSideDict = semesterIdNameTwoSideDictionary[semester]{
                let fbIdToNameDic = twoSideDict.idToName
                let fbNameToIdDic = twoSideDict.nameToId
                for s in (fbIdToNameDic.keys){
                    if s.hasPrefix(fixedID) {
                        temp.append(IdNamePair(id: s, name: (twoSideDict.get(id: s))!))
                        i += 1
                    }
                    if i >= suggestionLength{
                        tempSuggestion.suggestions[semester] = temp
                        return tempSuggestion
                    }
                }
                
                for c in (fbNameToIdDic.keys){
                    if c.uppercased().contains(fixedID) {
                        temp.append(IdNamePair(id: (twoSideDict.get(name: c))!, name: c))
                        i += 1
                    }
                    if i >= suggestionLength{
                        tempSuggestion.suggestions[semester] = temp
                        return tempSuggestion
                    }
                }
            
            }
            if temp.count>0{
                print("Find \(temp.count) suggestions from semester \(semester)")
                tempSuggestion.suggestions[semester] = temp
                temp = []
            }
        }
        return tempSuggestion
    }
    
    func suggestion(fixedID: String, suggestionLength: Int, semester: String) -> Suggestions{
        var tempSuggestion = Suggestions(suggestions: [:], terms: [])
        var temp:[IdNamePair] = []
        var i = 0
        
        if let twoSideDict = semesterIdNameTwoSideDictionary[semester]{
            let fbIdToNameDic = twoSideDict.idToName
            let fbNameToIdDic = twoSideDict.nameToId
            for s in (fbIdToNameDic.keys){
                if s.hasPrefix(fixedID) {
                    temp.append(IdNamePair(id: s, name: (twoSideDict.get(id: s))!))
                    i += 1
                }
                if i >= suggestionLength{
                    tempSuggestion.suggestions[semester] = temp
                    return tempSuggestion
                }
            }
            
            for c in (fbNameToIdDic.keys){
                if c.uppercased().contains(fixedID) {
                    temp.append(IdNamePair(id: (twoSideDict.get(name: c))!, name: c))
                    i += 1
                }
                if i >= suggestionLength{
                    tempSuggestion.suggestions[semester] = temp
                    return tempSuggestion
                }
            }
            
        }
        if temp.count>0{
            print("Find \(temp.count) suggestions from semester \(semester)")
            tempSuggestion.suggestions[semester] = temp
        }
        return tempSuggestion
    }
    
    

}

struct Suggestions {
    var suggestions:[String:[IdNamePair]]
    var terms:[String]
}

struct IdNamePair{
    let id:String
    let name:String
}


class CourseDictionary {
    
    let emptyLine = "."
    let markBooks    = "        BOOKS:"
    let markName     = "NAME:"
    let markBlock    = "        BLOCK:"
    let markTime     = "        TIMES:"
    let markTeacher  = "      TEACHER:"
    let markSylla    = "     SYLLABUS:"
    let markDesc     = "  DESCRIPTION:"
    let markTerm     = "         TERM:"
    let suggestionLength = 15
    
    var txt: String
    var input: String?
    var terms: [String]? // An array of all the terms in dictionary
    //var allTermDictionary: [[String: [String]]]?
    
    //var idToNameDic: [String: String]?
    
    var fbIdToNameDicsWithYear: [String: [String: String]]
    //The key is semester, and values are dictionaries that stores Ids to Names
    
    var fbNameToIdDicsWithYear: [String: [String: String]]
    //The key is semester, and values are dictionaries that stores Names to Ids
    
    var fbIdToNameDic: [String: String]
    //The firebase version of id to name dictionary
    //var nameToIdDic: [String: String]?
    
    var fbNameToIdDic: [String: String]
    //The firebase version of name to id dictionary
    
    var updateTime: String?
    var history: [String]? //stores all the history search
    var firebase: FirebaseService? //instance of firebase service, all data will be requested from here
    
    convenience init(fileName: String){
        self.init(fileName: fileName, type: "txt")
    }
    
    
    init(fileName: String, type: String){
        
        txt = "ready"
        history=[]
        
        fbIdToNameDic = ["isDone":"F"]
        fbNameToIdDic = ["isDone":"F"]
        //initialize with indicator meaning not finish loading data

        //with year
        fbIdToNameDicsWithYear = ["isDone": ["":""]]
        fbNameToIdDicsWithYear = ["isDone": ["":""]]
        //with year
        
        //allTermDictionary=[]
        //input = fileName+"."+type
//        let path = Bundle.main.path(forResource: "Data", ofType: "txt")
//        let start = DispatchTime.now() // <<<<<<<<<< Start time
//        
//        if let aStreamReader = StreamReader(path: path!) {
//            defer {
//                aStreamReader.close()
//            }
//            terms=[]
//            var i1=0
//            var i2=0
//            
//            var singleTermDictionary: [String: [String]] = [:]
//            var tempCourseInfoArray: [String] = []
//            var prevCourse:String = ""
//            var isName = false
//            
//            while let line = aStreamReader.nextLine() {
//                
//                if i1==0 && i2==0{
//                    let timeAndTerm = line.components(separatedBy: " ")
//                    updateTime = timeAndTerm[0]
//                    terms?.append(timeAndTerm[1]+" "+timeAndTerm[2])
//                    singleTermDictionary=[:]
//                }
//                if i2%14 == 1 {
//                    if(prevCourse != "" && (!tempCourseInfoArray.isEmpty)){
//                        isName=true
//                        //print("put \(prevCourse), tempCourseInfoArray: \(tempCourseInfoArray[2]+", "+tempCourseInfoArray[1]+"...\n\n")")
//                        singleTermDictionary.updateValue(tempCourseInfoArray, forKey: prevCourse)
//                    }//put a new value in the dic with the previos course name
//                    
//                    if line.hasPrefix(updateTime!){ // if we meet a new term
//                        i2=0
//                        prevCourse = ""
//                        let timeAndTerm = line.components(separatedBy: " ") //get the term
//                        terms?.append(timeAndTerm[1]+" "+timeAndTerm[2]) // put the term in the term list
//                        allTermDictionary?.append(singleTermDictionary)
//                        singleTermDictionary=[:]
//                    }else{  // if it is still in the courses section
//                        tempCourseInfoArray=[]
//                        var lines = line.components(separatedBy: " ")
//                        //singleTermDictionary.updateValue([], forKey: lines[0]+" "+lines[lines.count-1])
//                        prevCourse=lines[0]+" "+lines[lines.count-1]
//                    }
//                    
//                    
//                }else{
//                    if line != emptyLine{
//                        tempCourseInfoArray.append(line)
//                        if(line.hasPrefix(markName)){
//                            let courseName = line.replacingOccurrences(of: markName, with: "")
//                            if !courseName.hasPrefix(" LBF") && isName{//parse的java code
//                                nameToIdDic?.updateValue(prevCourse, forKey: courseName)
//                                idToNameDic?.updateValue(courseName, forKey: prevCourse)
//                                //print("\(prevCourse)  <=>  \(courseName)")
//                                isName=false
//                            }
//                            
//                        }
//                    }
//                    
//                }
//                
//                
//                i1 += 1
//                i2 += 1
//            }
//            
//            
//        }else{
//            print("failed txt")
//        }
//        
//        let end = DispatchTime.now()   // <<<<<<<<<<   end time
//        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
//        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
//        print("Init Dictionary correctly")
//        print("Time : \(timeInterval) seconds")
        
        
    }
    
    func start(){
        firebase = FirebaseService(courseDict: self)//test fb
        firebase?.start()
    }
    
    func addHistory(newHist: String) {
        if (history != nil) {
            history?.append(newHist)
        }
    }
    
    func latestHistory() -> String{
        if (history != nil){
            if ((history?.count)! > 0 ){
                let lines = history![(history?.count)!-1].components(separatedBy: "\n")
                if(lines.count > 1){
                    return lines[0]
                }else{
                    return history![(history?.count)!-1]
                }
            }
        }
        return ""
    }
    
    
    func latestTerm() -> String{
        if terms == nil{
            print("Error: empty terms")
            return "NONE"
        }
        return terms![0]
    }
    
    
    func suggestions(courseID: String) -> [String]{
        if fbIdToNameDic["isDone"] != "T" {
            return []
        }
        
        
        let fixedID = tryToUnderstandUserInput(userInput: courseID)
        var temp:[String] = []
        var i = 0
        
        //        //test fb
        //        var j = 0
        //        for s in (fbIdToNameDic.keys){
        //            if s.hasPrefix(fixedID) {
        //                print("FIREBASE RESULT: "+s+"\n"+(fbIdToNameDic[s])!)
        //                j += 1
        //            }
        //            if j >= suggestionLength{
        //                break
        //            }
        //        }
        //
        //        for c in (fbNameToIdDic.keys){
        //            if c.uppercased().contains(fixedID){
        //                print("FIREBASE RESULT: "+(fbNameToIdDic[c])!+"\n"+c)
        //                j += 1
        //
        //                if j >= suggestionLength{
        //                    break
        //
        //                }
        //            }
        //        }
        //        //test fb
        
        
        
        for s in (fbIdToNameDic.keys){
            if s.hasPrefix(fixedID) {
                temp.append(s+"\n"+(fbIdToNameDic[s])!)
                i += 1
            }
            if i >= suggestionLength{
                return temp.sorted()
            }
        }
        
        for c in (fbNameToIdDic.keys){
            if c.uppercased().contains(fixedID) {
                temp.append((fbNameToIdDic[c])!+"\n"+c)
                i += 1
            }
            if i >= suggestionLength{
                return temp.sorted()
            }
        }
        
        
        
        
        
        
        
        return temp.sorted()
    }
    
    //with the input of a course name, return the array of attributes it has
    //return [] if the course does not exist
//    func search(courseID: String) -> [String]{
//        
//        print("FIREBASE RESULTS\n")
//        print(courseID)
//        print(firebase?.search(courseID: courseID, completionHandler: searchCompleted(courseData:))) //test fb
//        print("FIREBASE RESULTS\n")
//        
//        if allTermDictionary == nil{
//            print("Error: empty allTermDictionary")
//            return []
//        }
//        let reasonedInput = tryToUnderstandUserInput(userInput: courseID)
//        if let result = allTermDictionary?[0][reasonedInput] {
//            print("find it in \(terms![0])")
//            print("***********")
//            print(result)
//            print([markTerm+terms![0]])
//            print("***********")
//            return result + [markTerm+terms![0]]
//        }else{
//            //var i = 1
//            var i = 0
//            while i < (terms?.count)! {
//                if let result = allTermDictionary?[i][reasonedInput]{
//                    print("find it in \(terms![i])")
//                    print("***********")
//                    print(result)
//                    print([markTerm+terms![i]])
//                    print("***********")
//                    return result + [markTerm+terms![i]]
//                }else{
//                    i += 1
//                    if i >= (allTermDictionary?.count)!{
//                        print("not found")
//                        return []
//                    }
//                }
//            }
//        }
//        print("Can't find the course \(courseID), reasonedInput: \(reasonedInput)")
//        return []
//    }
    
    //concurrent version of search
    func search(courseID: String, completionHandler:@escaping([String]) -> ()){
        print("FIREBASE RESULTS\n")
        print(courseID)
        firebase?.search(courseID: courseID, completionHandler: completionHandler)
        print("FIREBASE RESULTS\n")
        
    }
    
    //concurrent version of search by semester
    func search(semester: String,courseID: String, completionHandler:@escaping([String]) -> ()){
        print("FIREBASE RESULTS searchBySemester \(semester)\n")
        print(courseID)
        firebase?.searchBySemester(semester: semester, courseID: courseID, completionHandler: completionHandler)
        print("FIREBASE RESULTS searchBySemester \(semester)\n")
    }
    
    
    
    //helper func to reason the user input
    func tryToUnderstandUserInput(userInput: String) -> String{
        let s = userInput.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // to be completed
        
        return s
    }
    
    
    func searchCompleted(courseData: [String]) {
        print("========================")
        print(courseData)
        print("========================")
    }
    
    
    //["BLOCK: Block G", "CODE: \r\n          Fundamentals of Artificial Intelligence\r\n          \r\n\r\n         \r\n            [\r\n            \r\n          \r\n            sn\r\n                 \r\n            \r\n            ]\r\n          \r\n\r\n          \r\n            See Course Catalog for prerequisites.\r\n          \r\n\r\n      \r\n\r\n        ", "DESCRIPTION: http://registrar-prod.unet.brandeis.edu/registrar/schedule/course?acad_year=2014&crse_id=001761", "LOCATION: Volen Nat\'l Ctr for Complex119", "NAME: Fundamentals of Artificial Intelligence", "OPEN: ", "REQ: sn ", "SECTION: 1", "SYLLABUS: ", "TEACHER: http://www.brandeis.edu/facguide/person.html?emplid=e02e9cdcd77a4ce11e620139c379f43742682961", "TIME: LECTURE\nT,F  9:30 AM – 10:50 AM#"]
    
    //["BOOKS: http://www.bkstr.com/webapp/wcs/stores/servlet/booklookServlet?bookstore_id-1=1391&term_id-1=1171&div-1=&dept-1=COSI&course-1=101A&sect-1=1", "DESCRIPTION: http://registrar-prod.unet.brandeis.edu/registrar/schedule/course?acad_year=2017&crse_id=001761", "NAME: Fundamentals of Artificial Intelligence", "BLOCK: N", "TIMES: T,Th  2:00 PM - 3:20 PM", "TEACHER: http://www.brandeis.edu/facguide/person.html?emplid=e02e9cdcd77a4ce11e620139c379f43742682961"]
   //["         TERM:17 Spring"]
    
    
    
}
