//
//  AppDelegate.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 12/21/16.
//  Copyright © 2016 Yuanze Hu. All rights reserved.
//

import UIKit
import MMDrawerController
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var centerContainer: MMDrawerController?
    
    var theViewController: ViewController?
    
    var courseDictionary: CourseDictionary?
    
    var descCell : TableCellDescription?
    
    //var isAtViewController = false
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        print("didFinishLaunchingWithOptions in AppDelegate")
        
        
        courseDictionary = CourseDictionary(fileName: "Data")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "center")
        
        let centerVC = centerViewController as! ViewController
        
        theViewController = centerVC
        
        centerVC.navigationController?.navigationBar.tintColor = UIColor(red: 63.0/255.0, green: 81.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        
        
        
        centerVC.courseDictionary = courseDictionary//set the dictionary to ui
        
        
        let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
        
        let rightViewController = mainStoryboard.instantiateViewController(withIdentifier: "RightSideViewController") as! RightSideViewController

        
        let leftSideNav = UINavigationController(rootViewController: leftViewController)
        
        let rightSideNav = UINavigationController(rootViewController: rightViewController)
        
        leftSideNav.navigationBar.isHidden = true //hide the nav bar in LeftMenue
        
        rightSideNav.navigationBar.isHidden = true
        
        let centerNav = UINavigationController(rootViewController: centerViewController)

        
        
        
        centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav, rightDrawerViewController: rightSideNav)
        
        //UINavigationBar.appearance().barTintColor =
        
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView;
        
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView;
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()
        
        centerVC.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        
        
        
        
        
//        centerVC.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Title 1", size: 20)!]
        return true
    }
    
//    private func initCoreDataId(){
//        
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ID")
//        do{
//            if let result = try persistentContainer.viewContext.fetch(request)[0] as! NSManagedObject{
//                
//            }
//            
//        }catch{
//            print("Request Failed, delete failed")
//            return
//        }
//        
//        let newSaved = NSEntityDescription.insertNewObject(forEntityName: "ID", into: persistentContainer.viewContext)
//        newSaved.setValue(0, forKey: "id")
//        saveContext()
//    }
    
 
    public func setDescCell(descCell: TableCellDescription){
        self.descCell = descCell
    }
    
    
   
    
    func addHistory(newHistory: String){
        if(courseDictionary != nil){
            courseDictionary?.addHistory(newHist: newHistory)//delete later
            let newSaved = NSEntityDescription.insertNewObject(forEntityName: "MySearchHistory", into: persistentContainer.viewContext)
            
            newSaved.setValue(newHistory, forKey: "courseID" )
            self.saveContext()
        }else{
            print("dictionary is nil")
        }
        
    }
    
    
    
    
    // MARK: - Life Cycle
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationdIDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
        print("applicationWillTerminate")
    }
    
    
    
    // MARK: - Core Datan Managing Methods
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
    
    // MARK: Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("ERROR: Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func setSavedCourse(courseID: String, courseName: String, courseYear: String, courseTime: String){
//        var id: Int = -1
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ID")
//        do{
//            let ID = try persistentContainer.viewContext.fetch(request)
//            newSaved.
//            
//        }catch{
//            print("Request Failed, delete failed")
//            return
//        }
        let newSaved = NSEntityDescription.insertNewObject(forEntityName: "MyClasses", into: persistentContainer.viewContext)
        newSaved.setValue(courseID, forKey: "courseID" )
        newSaved.setValue(courseName, forKey: "courseName" )
        newSaved.setValue(courseTime, forKey: "courseTime" )
        newSaved.setValue(courseYear, forKey: "courseYear")
        self.saveContext()
    }
    
    //delete based on the given index
    //will be depreciated
    func deleteCourse(index: Int){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyClasses")
//        request.predicate = NSPredicate(format: "courseID == %@", courseId)
        do{
            let result = try persistentContainer.viewContext.fetch(request)
            persistentContainer.viewContext.delete(result[index] as! NSManagedObject)
            print("Deleted")
            self.saveContext()
        }catch{
            print("Request Failed, delete failed")
        }
    }
    
    //delete based on the given ID
    func deleteCourse(courseID: String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyClasses")
        request.predicate = NSPredicate(format: "courseID == %@", courseID)
        do{
            let result = try persistentContainer.viewContext.fetch(request)
            if result.count == 0 {
                print("The delete courseID does not exist, the courseID input is: \(courseID)")
                return
            }
            var i = 0
            for r in result as! [NSManagedObject] {
                persistentContainer.viewContext.delete(r)
                i += 1
            }
            print("deleted \(i) item(s) with courseID \(courseID)")
            self.saveContext()
        }catch{
            print("Request Failed, delete failed")
        }
    }
    
    
    
    //return the array with of each class and with all attributes in seperated lines
    func getAllSavedClass() -> [String]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyClasses")
        request.returnsObjectsAsFaults = false
        do{
            var resultArray:[String] = []
            
            let results = try persistentContainer.viewContext.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    var tempString = ""
                    let attributes = ["courseID","courseName","courseTime","courseYear"]
                    for attri in attributes{
                        if let classInfo = result.value(forKey: attri) as? String{
                            tempString.append(classInfo+"\n")
                        }
                    }
                    print("getAllSavedClass: \(tempString)")
                    resultArray.append(tempString)
                }
                return resultArray
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
    
    func getAllSavedClassObject() -> [NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MyClasses")
        request.returnsObjectsAsFaults = false
        do{
            let results = try persistentContainer.viewContext.fetch(request) as! [NSManagedObject]
            return results
        }
        catch{
            print("ERROR: Fetching result from core data failed.")
            return []
        }
    }
    
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
    
    private func termToString(term: String) -> Int{
        switch term {
        case "Spring":
            return 1
        case "SUMMER":
            return 2
        case "FALL":
            return 3
        default:
            return 0
        }
        
    }
    

}

