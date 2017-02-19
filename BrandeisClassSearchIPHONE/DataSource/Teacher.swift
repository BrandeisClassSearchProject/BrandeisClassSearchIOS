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
    let title:[String]
    let content:[String]
}

class Teacher {
    var email: String?
    var tel: String?
    var office: String?
    let name: String
    let title: String
    let pic: Data
    
    //var attributes:[teacherAttribute]
    
    
    init(htmlString: String) {
        if let doc = Kanna.HTML(html: htmlString, encoding: String.Encoding.utf8) {
            let temp_name = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//h1//a")
            let temp_pic = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='right']//div[@id='photo']//img//@src")
            let temp_contact_email = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='right']//div[@id='contact']//a")
            let temp_contact_telandloc = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='right']//div[@id='contact']//text()")
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
                title = a
            }else{
                title = ""
            }
            
            if let n = temp_name[0].text{
                name = n
            }else{
                name = ""
            }
            
            if let e = temp_contact_email[0].text{
                email = e
            }else{
                email = ""
            }
            
            if let t = temp_contact_telandloc[0].text{
                let telandloc = t.components(separatedBy: "\n")
                //tel = telandloc[0]
                
            }
            
            let titles = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='left']//div/p")
            let contents = doc.xpath("//body//div[@id='wrapper']//div[@id='banner']//div[@id='content']//div[@class='left']//div/text()")
        
        }else{
            name = ""
            title = ""
            pic = Data()
            print("Error: Kanna.HTML failed during init of Teacher")
        }
    }
    
    
    
}
