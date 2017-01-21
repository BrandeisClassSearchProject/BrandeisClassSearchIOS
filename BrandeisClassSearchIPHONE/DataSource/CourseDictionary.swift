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
    var allTermDictionary: [[String: [String]]]?
    var idToNameDic: [String: String]?
    var nameToIdDic: [String: String]?
    var updateTime: String?
    var history: [String]?
    
    
    convenience init(fileName: String){
        self.init(fileName: fileName, type: "txt")
    }

    
    init(fileName: String, type: String){
        txt = "ready"
        history=[]
        idToNameDic=[:]
        nameToIdDic=[:]
        allTermDictionary=[]
        input = fileName+"."+type
        let path = Bundle.main.path(forResource: "Data", ofType: "txt")
        let start = DispatchTime.now() // <<<<<<<<<< Start time
        
        if let aStreamReader = StreamReader(path: path!) {
            defer {
                aStreamReader.close()
            }
            terms=[]
            var i1=0
            var i2=0
            
            var singleTermDictionary: [String: [String]] = [:]
            var tempCourseInfoArray: [String] = []
            var prevCourse:String = ""
            var isName = false
            
            while let line = aStreamReader.nextLine() {
                
                if i1==0 && i2==0{
                    let timeAndTerm = line.components(separatedBy: " ")
                    updateTime = timeAndTerm[0]
                    terms?.append(timeAndTerm[1]+" "+timeAndTerm[2])
                    singleTermDictionary=[:]
                }
                if i2%14 == 1 {
                    if(prevCourse != "" && (!tempCourseInfoArray.isEmpty)){
                        isName=true
                        print("put \(prevCourse), tempCourseInfoArray: \(tempCourseInfoArray[2]+", "+tempCourseInfoArray[1]+"...\n\n")")
                        singleTermDictionary.updateValue(tempCourseInfoArray, forKey: prevCourse)
                    }//put a new value in the dic with the previos course name

                    if line.hasPrefix(updateTime!){ // if we meet a new term
                        i2=0
                        prevCourse = ""
                        let timeAndTerm = line.components(separatedBy: " ") //get the term
                        terms?.append(timeAndTerm[1]+" "+timeAndTerm[2]) // put the term in the term list
                        allTermDictionary?.append(singleTermDictionary)
                        singleTermDictionary=[:]
                    }else{  // if it is still in the courses section
                        tempCourseInfoArray=[]
                        var lines = line.components(separatedBy: " ")
                        //singleTermDictionary.updateValue([], forKey: lines[0]+" "+lines[lines.count-1])
                        prevCourse=lines[0]+" "+lines[lines.count-1]
                    }
                    
                    
                }else{
                    if line != emptyLine{
                        tempCourseInfoArray.append(line)
                        if(line.hasPrefix(markName)){
                            let courseName = line.replacingOccurrences(of: markName, with: "")
                            if !courseName.hasPrefix(" LBF") && isName{//hard code 实现 需要改 parse的java code
                                nameToIdDic?.updateValue(prevCourse, forKey: courseName)
                                idToNameDic?.updateValue(courseName, forKey: prevCourse)
                                print("\(prevCourse)  <=>  \(courseName)")
                                isName=false
                            }
                            
                        }
                    }
                    
                }
                
                
                i1 += 1
                i2 += 1
            }
            
            
        }else{
            print("failed txt")
        }
        
        let end = DispatchTime.now()   // <<<<<<<<<<   end time
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
        print("Init Dictionary correctly")
        print("Time : \(timeInterval) seconds")
        

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
        let fixedID = tryToUnderstandUserInput(userInput: courseID)
        var temp:[String] = []
        var i = 0
        
        for s in (idToNameDic?.keys)!{
            if s.hasPrefix(fixedID) {
                temp.append(s+"\n"+(idToNameDic?[s])!)
                i += 1
            }
            if i >= suggestionLength{
                return temp.sorted()
            }
        }
        
        for c in (nameToIdDic?.keys)!{
            if c.uppercased().contains(fixedID){
                temp.append((nameToIdDic?[c])!+"\n"+c)
                i += 1
            
                if i >= suggestionLength{
                    return temp.sorted()

                }
            }
        }
        
        return temp.sorted()
    }
    
    //with the input of a course name, return the array of attributes it has
    //return [] if the course does not exist
    func search(courseID: String) -> [String]{
        if allTermDictionary == nil{
            print("Error: empty allTermDictionary")
            return []
        }
        let reasonedInput = tryToUnderstandUserInput(userInput: courseID)
        if let result = allTermDictionary?[0][reasonedInput] {
            print("find it in \(terms![0])")
            return result + [markTerm+terms![0]]
        }else{
            var i=1
            while i < (terms?.count)! {
                if let result = allTermDictionary?[i][reasonedInput]{
                    print("find it in \(terms![i])")
                    return result + [markTerm+terms![i]]
                }else{
                    i += 1
                }
            }
        }
        print("Can't find the course \(courseID), reasonedInput: \(reasonedInput)")
        return []
    }
    
    //helper func to reason the user input
    func tryToUnderstandUserInput(userInput: String) -> String{
        let s = userInput.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // to be completed
    
        return s
    }
    
}
