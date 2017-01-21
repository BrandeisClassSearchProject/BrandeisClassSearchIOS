//
//  Book.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/19/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import Foundation

class Book {
    let author: String?
    let edition: String?
    let ISBN: String?
    let copyrightYear: String?
    let publisher: String?
    let imageURL: String?
    
    
    init(author:String, edition: String, ISBN: String, copyright: String, publisher: String, imageUrl: String) {
        self.author = author
        self.copyrightYear = copyright
        self.edition = edition
        self.publisher = publisher
        self.ISBN = ISBN
        self.imageURL = imageUrl
    }
    
}
