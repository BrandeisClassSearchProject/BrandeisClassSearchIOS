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
    
    var section = ""
    
    var code = ""
    
    
    init(searchResultArray : [String]) {
        var time = ""
        courseDataItemStore = []
        var tempCourseDataItemStore : [CourseDataItem] = []
        for result in searchResultArray{
            let courseDataItem = CourseDataItem(rawDataItem: result)
            if courseDataItem.attribute == .TIME {
                time = courseDataItem.rawInput
            }
            if courseDataItem.attribute == .CODE{
                code = courseDataItem.rawInput
            }else if courseDataItem.attribute == .SECTION{
                section = courseDataItem.rawInput
            }else{
                tempCourseDataItemStore.append(courseDataItem)
            }
            
        }
        
        for item in tempCourseDataItemStore {
            print("print temp")
            print(item.attribute.getHeader())
            print(item.rawInput)
            print(item.resultList)
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
            if item.attribute != .BLOCK && item.attribute != .TERM && item.attribute != .NAME && item.attribute != .SYLLABUS  && item.attribute != .TIME && item.attribute != .ERROR {
                if !(item.attribute == .LOCATION && item.rawInput == ""){
                    courseDataItemStore.append(item)
                }
                
                
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
    
    //Type is unique in an store
    public func getResult(type: Attribute) -> [String]{
        for item in courseDataItemStore {
            if item.attribute == type {
                return item.resultList
            }
        }
        print("ERROR: getResult in ItemStore cannot find result for type \(type.getHeader())\n       Return an empty array")
        return []
    }
    
    public func isDone() -> Bool{
        var isDone = false
        for item in courseDataItemStore {
            isDone = isDone && item.isDone
        }
        return isDone
    }
    
    public func summary(){
        for item in courseDataItemStore{
            print(item.attribute.getHeader())
            print(item.rawInput)
            print(item.resultList)
            //print(item.resultList2)
            print("\n")
        }
    }
    
    
}
