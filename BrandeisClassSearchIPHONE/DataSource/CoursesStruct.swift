//
//  CoursesStruct.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 2/5/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import Foundation

public struct Course{
    let courseID:String
    let courseName:String
    let Time:String
    
}

public struct CoursesInTerm{
    var num = 1
    let term: String
    var courses: [Course]
}


func >(lhs : CoursesInTerm, rhs : CoursesInTerm) -> Bool{
    print("custimzed > comparing two CoursesInTerm Struct")
    let leftArray = lhs.term.components(separatedBy: " ")
    let rightArray = rhs.term.components(separatedBy: " ")
    
    let leftyear = Int(leftArray[0])
    let rightyear = Int(rightArray[0])
    
    if leftyear! > rightyear! {
        return true
    }else if leftyear! < rightyear!{
        return false
    }else{
        let leftTerm = termToString(term: leftArray[leftArray.count-1])
        let rightTerm = termToString(term: rightArray[rightArray.count-1])
        return leftTerm > rightTerm
    }
    return false
}

func termToString(term: String) -> Int{
    switch term {
    case "Spring":
        return 3
    case "SUMMER":
        return 2
    case "FALL":
        return 1
    default:
        return 0
    }

}
