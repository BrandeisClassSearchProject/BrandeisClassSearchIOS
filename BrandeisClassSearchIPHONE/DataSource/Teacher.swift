//
//  Teacher.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 2/18/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//
//  the data structure that stores all the relative infomation about a teahcer
//  the struct teacherAttribute is each item on the website
//  example http://www.brandeis.edu/facultyguide/person.html?emplid=05d12bcb1995d3170bc0419382f116977ac718f8

import Kanna


struct teacherAttribute {
    let title:String
    let content:String
}

class Teacher {
    var email: String?
    var tel: String?
    var office: String?
    let name: String
    let title: String
    let pic: Data
    var contents : [teacherAttribute]
    //var attributes:[teacherAttribute]
    
    
    init(htmlString: String) {
        if let doc = Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8) {
            let temp_name = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//h1//a")
            let temp_pic = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='right']//div[@id='photo']//img//@src")
            //let temp_contact_email = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='right']//div[@id='contact']//a")
            let temp_contact_telandloc = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='right']//div[@id='contact']")
            let teacherTitle =  doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='left']//div[@id='title']")
            
            //see if the teacher has a url for his/her pic
            if let url = temp_pic[0].text {
                print("loading teacher pic")
                do{
                    pic = try Data(contentsOf: URL(string : url)!)
                } catch {
                    pic = Data() //if for some reason the image cannot be loaded, then set it to empty
                    print("loading teacher pic failed")
                }
            }else{
                pic = Data()
            }
            
            if let a = teacherTitle[0].text {
                title = a.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }else{
                title = ""
            }
            
            if let n = temp_name[0].text{
                name = n.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }else{
                name = ""
            }
            
//            if let e = temp_contact_email[0].text{
//                email = e.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//            }else{
//                email = ""
//            }
            
            if let text = temp_contact_telandloc[0].text{
                let contactInformation:[String] = text.clearWhiteSpace()
                if contactInformation.count == 3{
                    email = contactInformation[0]
                    tel = contactInformation[1]
                    office = contactInformation[2]
                    print("office: \(office)")
                }else{
                    email = ""
                    tel = ""
                    office = ""
                }
            }
            
            
            
//            let titles = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='left']//div/p")
//            for t in titles{
//                if let text_t = t.text{
//                    print("in titles line: \(text_t)")
//                }else{
//                    print("in titles line: NO STRING, TEXT_T IS NIL!")
//                }
//                
//            }
//            
//            let contents = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='left']//div/text()")
//            for t in contents{
//                if let text_t = t.text{
//                    print("in contents line: \(text_t)")
//                }else{
//                    print("in contents line: NO STRING, TEXT_T IS NIL!")
//                }
//                
//            }
            
            
            let allcontents = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='left']/div")
            contents = []
            var keepChecking = true
            for t in allcontents{
                
                
                if let text = t.text{
                    let temp_attr = makeTeacherAttribute(text: text)
                    if keepChecking{
                        if temp_attr.title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != title{
                            contents.append(temp_attr)
                        }else{
                            keepChecking = false
                        }
                    }else{
                        contents.append(temp_attr)
                    }
                    
                    //print("content: \(text)")
                }
              
                print("---div in allcontents---")
            }
        
        }else{
            name = ""
            title = ""
            pic = Data()
            contents = []
            print("Error: Kanna.HTML failed during init of Teacher")
        }
    }
    
    
    
    func getAttributeTitle(index: Int) -> String{
        return contents[index].title
    }
    
    func getAttributeContent(index: Int) -> String{
        return contents[index].content
    }
    
    func introduce(){
        print("Introduce this teacher:")
        print("name: \(name)")
        print("title: \(title)")
        print("is pic empty \(pic.isEmpty)")
        if let e = email{
            print("email: \(e)")
        }
        
        for c in contents{
            print("***title  :\(c.title)")
            print("***content:\(c.content)")
        }
        
    }
    
    func makeTeacherAttribute(text: String) -> teacherAttribute{
        
        var findStart = false
        var findEnd = false
        var chars:[Character] = []
        var i = 0
        
        for char in text.characters {
            
            if !findStart{
                print("before start: \(char)")
            }
            
            if char != " " && char != "\n" && char != "\r"  && char != "\r\n"{
                findStart = true
            }
            
            
            
            if findStart && (char == "\n" || char == "\r" || char == "\r\n"){
                findEnd = true
                break
            }
            
            if findStart && !findEnd{
                chars.append(char)
            }
            
            i+=1
        }
        
        let s = String(chars)
        
        print("the trimed string is:\"\(s)\"")
        
//        let temp_array = text.clearWhiteSpace()
//        
//        if temp_array.count < 1{
//            return teacherAttribute(title: "", content: "")
//        }else{
//            var s = ""
//            for i in 1...temp_array.count{
//                s = s + temp_array[i] + "\n"
//            }
//            return teacherAttribute(title: temp_array[0], content: s)
//        }
        
        let sub: String = text.substring(from: text.index(text.startIndex, offsetBy: i))
  
        return teacherAttribute(title: s, content: sub.clearWhiteSpaceToString())

        
    }
    
    var x = 0
    
    
    
    
}



extension String{
    
    func trimWhiteSpace() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func clearWhiteSpace() -> [String]{
        var startRecording = false
        var strings:[String] = []
        var temp_String:[Character] = []
        var prevChar: Character = " "
        for c in self.characters {
            
            if c != "\r\n" && c != " " && c != "\n" && !startRecording{
                startRecording = true
            }
            
            if  ((c == "\r\n" || c == "\n") || (c == " " && prevChar == " ")) && startRecording{
                startRecording = false
                if temp_String != []{
                    strings.append(String(temp_String))
                    temp_String = []
                }
            }
            
            if startRecording {
                temp_String.append(c)
            }
            prevChar = c
        }
        return strings
    }
    
    func clearWhiteSpaceToString() -> String{
        var startRecording = false
        var tempChars:[Character] = []
        var prevChar: Character = " "
        for c in self.characters {
            
            if c != "\r\n" && c != " " && c != "\n" && !startRecording{
                startRecording = true
            }
            
            if  ((c == "\r\n" || c == "\n") || (c == " " && prevChar == " ")) && startRecording{
                startRecording = false
                tempChars.append("\n")
            }
            
            if startRecording {
                tempChars.append(c)
            }
            prevChar = c
        }
        print("tempChars:---\(tempChars)---")
        return String(tempChars)
    }
}
