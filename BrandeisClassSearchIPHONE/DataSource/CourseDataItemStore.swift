//
//  CourseDataItemStore.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/11/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//  stores an array of CourseDataItem a wrapper class

import Foundation

class CourseDataItemStore {
    var courseDataItemStore: [CourseDataItem]
    
    
    init(searchResultArray : [String]) {
        var time = ""
        courseDataItemStore = []
        var tempCourseDataItemStore : [CourseDataItem] = []
        for result in searchResultArray{
            let courseDataItem = CourseDataItem(rawDataItem: result)
            if courseDataItem.attribute == .TIME {
                time = courseDataItem.rawInput
            }
            tempCourseDataItemStore.append(courseDataItem)
        }
        
        
        
        for item in tempCourseDataItemStore {
            if item.attribute == .NAME{
                courseDataItemStore.append(item)
                break
            }
        }
        
        
        for item in tempCourseDataItemStore {
            if item.attribute == .TERM{
                courseDataItemStore.append(item)
                break
            }
        }
        
        for item in tempCourseDataItemStore {
            if item.attribute == .BLOCK{
                item.appendRawInput(input: time)
                courseDataItemStore.append(item)
                break
            }
        }
        
       
        for item in tempCourseDataItemStore {
            if item.attribute != .BLOCK && item.attribute != .TERM && item.attribute != .NAME && item.attribute != .SYLLABUS  && item.attribute != .TIME{
                courseDataItemStore.append(item)
            }
            
        }
        
        
        
        for item in courseDataItemStore{
            item.execute()
        }//execute all, download concurrently
    }
    
    private func findAndAppendTo (fromArray: [CourseDataItem], toArray: [CourseDataItem], itemAttribute: Attribute, time: String?){
        
        
    }

    
    
    
    public func updateResults(attribute: Attribute, newResults: [String]){
        
        
    }
    
    public func getResult(index: Int) -> [String]{
        return courseDataItemStore[index].resultList
    }
    
    public func isDone() -> Bool{
        var isDone = false
        for item in courseDataItemStore {
            isDone = isDone && item.isDone
        }
        return isDone
    }
    
    
}
