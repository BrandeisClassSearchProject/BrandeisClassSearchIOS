//
//  CoursesInTerms.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 2/15/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import Foundation

class CoursesInTerms{
    
    var courseInTerms : [CoursesInTerm]
    
    init(CourseInTerms: [CoursesInTerm]) {
        courseInTerms = CourseInTerms
    }
    
    func printCoursesInTerms(){
        print("Print all coursesInTerms")
        for ct in courseInTerms{
            print("---")
            print("Term:\(ct.term)")
            print("Num:\(ct.num)")
            for c in ct.courses{
                print(c.courseID)
                print(c.courseName)
                print(c.Time)
            }
            print("---")
        }
    }
    
    func count() -> Int{
        var count = 0
        for ct in courseInTerms{
            count += ct.num
        }
        return count
    }
    
    func get(index : Int) -> Course{
        var i = index
        for c in courseInTerms{
            if i < c.num {
                if i==0{
                    return Course(courseID: "header",courseName: "header",Time: "20"+c.term)
                }else{
                    return c.courses[i-1]
                }
            }else{
                i = i - c.num
            }
        }
        return Course(courseID: "",courseName: "",Time: "")
    }
    
    func getTerm(index:Int) ->CoursesInTerm{
        var i = index
        var j = 0
        for c in courseInTerms{
            if i < c.num{
                return courseInTerms[j]
            }else{
                i = i - c.num
                j = j + 1
            }
        }
        print("ERROR: Can't find the term")
        return CoursesInTerm(num: 0,term: "",courses: [])
    }
    
    
    
    func canEdit(index : Int) -> Bool {
        var i = index
        for c in courseInTerms{
            if i < c.num {
                if i==0{
                    return false
                }else{
                    return true
                }
            }else{
                i = i - c.num
            }
        }
        return false
    }
    
    func remove(index : Int) {
        var i = index
        var j = 0
        for c in courseInTerms{
            if i < c.num {
                if i==0{
                    print("cannot remove header")
                    return
                }else{
                    courseInTerms[j].num = courseInTerms[j].num - 1
                    courseInTerms[j].courses.remove(at: i-1)
                    print("remove course at \(j) at \(i-1)")
                    return
                }
            }else{
                i = i - c.num
            }
            j = j+1
        }
    }
    
    
}
