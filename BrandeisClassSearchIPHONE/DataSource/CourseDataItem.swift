//
//  CourseDataItem.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/9/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

enum Attribute {
    case NAME, BOOK, BLOCK, TEACHER, SYLLABUS, DESCRIPTION, TERM, LOCATION, REQ, SECTION, CODE, TIME, ERROR
    
    func getHeader() -> String{
        switch self {
            
        case Attribute.NAME:
            return "NAME:"
        case Attribute.BOOK:
            return "BOOKS:"
        case Attribute.BLOCK:
            return "BLOCK:"
        case Attribute.TEACHER:
            return "TEACHER:"
        case Attribute.SYLLABUS:
            return "SYLLABUS:"
        case Attribute.DESCRIPTION:
            return "DESCRIPTION:"
        case Attribute.TERM:
            return "TERM:"
        case Attribute.CODE:
            return "CODE:"
        case Attribute.REQ:
            return "REQ:"
        case Attribute.SECTION:
            return "SECTION:"
        case Attribute.LOCATION:
            return "LOCATION:"
        case Attribute.TIME:
            return "TIMES:"
        case Attribute.ERROR:
            print("Error")
            return ""
        }
    }
}

let attributeList = [Attribute.NAME,Attribute.BOOK,Attribute.BLOCK,Attribute.TEACHER,Attribute.SYLLABUS,Attribute.DESCRIPTION,Attribute.TERM,Attribute.CODE,Attribute.LOCATION,Attribute.REQ,Attribute.SECTION,Attribute.TIME]


class CourseDataItem {
    let Error = "Error"
    var attribute: Attribute = Attribute.ERROR
    var rawInput: String = ""
    var resultList = [String]() //the complete info of an item
    lazy var resultList2 = [String]() //essentials thats needed for the table cell
    lazy var pictureList = [Data]() //an array of data objects which will contains pictures
    var isDone = false
    
    var teacher:Teacher?
    
    //no internet connection during init step, nothing is done
    //resultlList is not empty only if execute() is called
    init(rawDataItem: String) {
        
        let rawData = rawDataItem.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        for s in attributeList{
            if rawData.hasPrefix(getHeader(atrr: s)){
                attribute = s
                rawInput = rawData.replacingOccurrences(of: getHeader(atrr: s), with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                return
            }
        }
        print("Error in CourseDataItem, rawDataItem: \(rawDataItem)")
        rawInput = Error
        attribute=Attribute.ERROR
    }
    
    func getHeader(atrr : Attribute) -> String{
        switch atrr {
            
        case Attribute.NAME:
            return "NAME:"
        case Attribute.BOOK:
            return "BOOKS:"
        case Attribute.BLOCK:
            return "BLOCK:"
        case Attribute.TEACHER:
            return "TEACHER:"
        case Attribute.SYLLABUS:
            return "SYLLABUS:"
        case Attribute.DESCRIPTION:
            return "DESCRIPTION:"
        case Attribute.TERM:
            return "TERM:"
        case Attribute.CODE:
            return "CODE:"
        case Attribute.REQ:
            return "REQ:"
        case Attribute.SECTION:
            return "SECTION:"
        case Attribute.LOCATION:
            return "LOCATION:"
        case Attribute.TIME:
            return "TIMES:"
        case Attribute.ERROR:
            print("Error")
            return ""
        }
    }
    
    public func appendRawInput(input: String)  {
        self.rawInput = rawInput + "\n\(input)"
        print("appended raw Inp: \(self.rawInput)")
    }
    

    
    //the method called from outside to start downloading stuffs
    public func execute(){
        if attribute == .BOOK || attribute == .DESCRIPTION || attribute == .TEACHER || attribute == .SYLLABUS{
            let queue = DispatchQueue(label: attribute.getHeader())
            queue.async {
                print("new Background thread for \(self.attribute.getHeader())\n")
                self.doFetchWithAlamofire(urlString: self.rawInput)
            }
        }else if attribute == .ERROR {
            print("Error ,can't fetch")
        }else{
            doFetchRaw()
        }
    }
    
    private func doFetchRaw(){
        resultList.append(rawInput)
        isDone = true
    }

    private func doFetchWithAlamofire(urlString: String) {

        Alamofire.request(urlString).responseString(completionHandler: {
            response in
            print("is Successful?? \(response.result.isSuccess)")
            if let html = response.result.value {
                let result = self.setResult(htmlString: html)
                if result.count >= 1 {
                    self.resultList = result
                    print("doFetchWithAlamofire ok set result list to \(self.resultList[0])")
                }
                self.isDone = true
            }else{
                print("url not working, url: \(urlString)")
                self.isDone = true
            }
        })
        
    }
    
    
    //for now only these three needs to be parsed
    private func setResult(htmlString:String) -> [String]{
        switch attribute {
        case .TEACHER:
            return parseWithKannaTeacher(htmlString: htmlString)
        case .DESCRIPTION:
            return parseWithKannaDescription(htmlString: htmlString)
        case .BOOK:
            return parseWithKannaBook(htmlString: htmlString)
        case .SYLLABUS:
            return parseWithKannaSyllabus(htmlString: htmlString)
        default:
            print("setResult is nothing Attri:  \(attribute.getHeader())")
            return []
        }
    }
    
    
    private func parseWithKannaTeacher(htmlString: String) -> [String] {
        if let doc = Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8) {
            var results: [String] = []
            
            //get the name of the teacher
            let teacherName = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//h1//a")
            
            //get teacherPic
            let teacherPic = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='right']//div[@id='photo']//img//@src")
            
            if teacherPic.count > 0 {
                if let url = teacherPic[0].text {
                    print("loading teacher pic")
                    do{
                    
                        let data = try Data(contentsOf: URL(string : url)!)
                        pictureList.append(data)
                    } catch {
                        print("loading teacher pic failed")
                    }
                }
            }
            
            
            
            //get teacher education
            let teacherEdu = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='left']//div[@id='degrees']/text()")//[preceding-sibling::br]
            
            //get the title
            let teacherTitle =  doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='left']//div[@id='title']")
            
            
            print("the length is \(teacherName.count)")
            if teacherName.count == 1{
                results.append(teacherName[0].text!)
                resultList2.append(teacherName[0].text!)
            }else{
                print("something wrong with teacherName, count isnt 1")
                for a in teacherName{
                    print(a.text ?? "no value")
                }
            }
            
            if teacherEdu.count > 0 {
                print("the teacher's degree is \(teacherEdu[0].text!)")
                var tempEdu = ""
                for a in teacherEdu{
                    if let b = a.text{
                        let trimed = b.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        print("-> \(trimed)")
                        if trimed != "" {
                            tempEdu = tempEdu + trimed + "\n"
                        }
                        
                    }
                    
                }
                resultList2.append(tempEdu.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))

            }else{
                print("something wrong, the teacherEdu has less thann 1")
                for a in teacherEdu{
                    print(a.text ?? "no value")
                }
            }
            
            
            if teacherTitle.count > 0 {
                if let title = teacherTitle[0].text {
                    print("teacherTitle: \(title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))")
                    resultList2.append(title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                }
            }
            
            
            teacher = Teacher(htmlString: htmlString)
            //teacher?.introduce()
            return results
        }
        print("parseWithKannaTeacher Failed  htmlString: \(htmlString)")
        return []
        
        
    }
    
    private func parseWithKannaSyllabus(htmlString: String) -> [String] {
        return [rawInput]
    }
    
    //the simplest one
    private func parseWithKannaDescription(htmlString: String) -> [String] {
        if let doc = Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8) {
            var desc = [""]
            var tempString = ""
//            let requirements = doc.css("body span")
//            for s in requirements{// get all the university requirements like sn, hum ...
//                if var a = s.text {
//                    a = a.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//                    if a != "" {
//                        tempString.append(a+"  ")
//                    }
//                }
//            }
//            
//            if requirements.count>0{
//                tempString.append("\n")
//            }
            let body = doc.css("body p")
            if body.count<1{
                return []
            }
            tempString.append(body[0].text!)
            desc[0]=tempString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<br />", with: "\n")
            print("parseWithKannaDescription done  \(desc[0])")
            return desc
        }else{
            print("parseWithKannaDescription Failed  htmlString: \(htmlString)")
            return []
        }
    }
    
    private func parseWithKannaBook(htmlString: String) -> [String] {
        //let booksInfo = [String]()
        print("parseWithKannaBook")
        if let doc = Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8) {
            let materialsRequired =  doc.xpath("//div[@class='efCourseHeader-list']//p//a[@href='#material-group-name_REQUIRED_1_1']")
            if materialsRequired.count < 1 {
                print("no textbooks information")
                return ["no textbooks information","The instructor might haven't uploaded yet"]
            }
            if let materialsRequiredString = materialsRequired[0].text {
                print("books: \(materialsRequiredString)")
                resultList2.append(materialsRequiredString)
            }
            var results: [String] = []
            

            let roots = doc.xpath("//ul[@id='material-group-list_REQUIRED_1_1']") //save a closer one for reusing
            
            if roots.count != 1{
                print("something wrong...number of [material-group-list_REQUIRED_1_1] is not one")
                return []
            }//stop if roots is not one
            
            let root = roots[0]
            
            
            
            let imgs = root.xpath("//span[@id='materialTitleImage']//img/@src")//the attribute stores all the url for images
            
            let titles = root.xpath("//span[@id='materialTitleImage']//img/@alt")//the attribute stores all the name of the book
            
            if imgs.count != titles.count {
                print("something wrong...cannot have correct imgs, number of imgs is \(imgs.count)")
                return []
            }
            
            //var bookGroupDetails = root.xpath("//div[@class='material-group-details top-set ']")
            let bookMaterialGroupDetail = root.xpath("//div[@class='material-group-edition']")
            
            if bookMaterialGroupDetail.count != titles.count{
                print("something wrong...cannot have correct number of details and titles")
                return []
            }
            
            for i in 0...titles.count-1 {
                var tempString = ""
                if let text = titles[i].text {
                    tempString += "Title:" + text + "\n"
                }
                
                if let img = imgs[i].text{
                    tempString += "Image:" + img + "\n"
                }
                //print(bookMaterialGroupDetail[i].content ?? "no content")
                for s in bookMaterialGroupDetail[i].css("span"){
                    if let sp = s.text {
                        if !sp.isEmpty{
                            tempString += sp + "\n"
                        }
                    }else{
                        print("What? The s.text is nil")
                    }
                }
                print("   Append at \(i): \n\(tempString)")
                results.append(tempString)
            }
            
            if results.count == 0 {
                print("  There is no books or something went wrong  ")
            }
            return results
        }else{
            print("parseWithKannaBook Failed  htmlString: ")
            return []
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}
