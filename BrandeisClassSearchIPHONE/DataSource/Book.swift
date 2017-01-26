//
//  Book.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/19/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import Foundation

class Book {
    var author: String?
    var edition: String?
    var ISBN: String?
    var copyrightYear: String?
    var publisher: String?
    var imageURL: String?
    var title: String?
    
    
    //we assume the given string is correct
    init(allInfoAboutBook: String) {
        
        let infoArray: [String] = allInfoAboutBook.components(separatedBy: "\n")
        
        for infoAboutBook in infoArray {
            if infoAboutBook.hasPrefix("Author:"){
                author = infoAboutBook.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            }else if infoAboutBook.hasPrefix("ISBN:"){
                ISBN = infoAboutBook.replacingOccurrences(of: "ISBN:", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            }else if infoAboutBook.hasPrefix("Copyright Year:"){
                copyrightYear = infoAboutBook.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            }else if infoAboutBook.hasPrefix("Publisher:"){
                publisher = infoAboutBook.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            }else if infoAboutBook.hasPrefix("Edition:"){
                edition = infoAboutBook.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            }else if infoAboutBook.hasPrefix("Title:"){
                title = infoAboutBook.replacingOccurrences(of: "Title:", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

            }else if infoAboutBook.hasPrefix("Image:"){
                imageURL = "https:"+infoAboutBook.replacingOccurrences(of: "Image:", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
        }
        
    }

    
    public func infos() -> String{
        var s = ""
        if let a = author {
            s += a + "\n"
        }
        if let e = edition {
            s += e + "\n"
        }
        if let p = publisher {
            s += p
        }
        return s
    }

    
}
