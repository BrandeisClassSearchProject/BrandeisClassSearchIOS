//
//  FileUtil.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 12/28/16.
//  Copyright © 2016 Yuanze Hu. All rights reserved.
//

import Foundation

class FileUtil {
    class func open(path: String, encoding: String.Encoding = String.Encoding.utf8) -> String? {
        if FileManager().fileExists(atPath: path) {
            do {
                return try String(contentsOfFile: path, encoding: encoding)
            
            } catch let error as NSError {
                print(error.code)
                return nil
            }
        }
        print("file not exist from FileUtil \(path)")
        return  nil
    }
    
    class func save(path: String, _ content: String, encoding: String.Encoding = String.Encoding.utf8) -> Bool {
        do {
            try content.write(toFile: path, atomically: true, encoding: encoding)
            return true
        } catch let error as NSError {
            print(error.code)
            return false
        }
    }
}
