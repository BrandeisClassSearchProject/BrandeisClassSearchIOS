//
//  CoreDataManager.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 2/15/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//


//This class manages all core data operations
//dont playing with core data directly


import CoreData



class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "UserSavedClasses")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("ERROR: Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getAllSavedClassInTerms() -> [CoursesInTerm] {
        var coursesInTerms: [CoursesInTerm] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyClasses")
        request.returnsObjectsAsFaults = false
        do{
            var termsToCoursesInTermDict = [String:CoursesInTerm]()
            
            let results = try persistentContainer.viewContext.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let term = result.value(forKey: "courseYear") as? String{
                        var cInT = termsToCoursesInTermDict[term]
                        if cInT == nil {
                            cInT = CoursesInTerm(num: 1, term: term, courses: [])
                        }
                        
                        let newCourse = Course(
                            courseID: result.value(forKey: "courseID") as? String ?? "",
                            courseName: result.value(forKey: "courseName") as? String ?? "",
                            Time: result.value(forKey: "courseTime") as? String ?? "")
                        print("newCourse.courseID \(newCourse.courseID)")
                        cInT?.courses.append(newCourse)
                        cInT?.num = (cInT?.num)! + 1
                        print("num \(cInT?.num)")
                        termsToCoursesInTermDict[term] = cInT
                        // let attributes = ["courseID","courseName","courseTime","courseYear"]
                        
                    }else{
                        print("ERROR: the class does not have courseYear which is super weird, skip this course")
                    }
                }
                
                
                
                var keysTerm = [String](termsToCoursesInTermDict.keys)
                let n = keysTerm.count
                if n == 0{
                    return coursesInTerms
                }else if n > 1{
                    for i in 0...n-2 {
                        var max = i
                        for j in i+1...n-1{
                            if(termToInt(s: keysTerm[j]) > termToInt(s: keysTerm[max])){
                                max = j
                            }
                        }
                        
                        if max != i{
                            let temp = keysTerm[max]
                            keysTerm[max] = keysTerm[i]
                            keysTerm[i] = temp
                        }
                    }
                }
                
                
                for t in keysTerm {
                    coursesInTerms.append(termsToCoursesInTermDict[t]!)
                }
                
                return coursesInTerms
            }else{
                print("getAllSavedClass: the MyClass in core data has 0 elements")
                return []
            }
            
        }
        catch{
            print("ERROR: Fetching result from core data failed.")
            return []
        }
    }
    
    private func termToInt(s: String) -> Int{
        let a = s.components(separatedBy: " ")
        return ((Int(a[0]) ?? 0) * 10 + termToString(term: a[a.count-1]))
    }
    
    
    
    
    
    
}
