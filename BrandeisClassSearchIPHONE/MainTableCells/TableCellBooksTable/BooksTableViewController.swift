//
//  BooksTableViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 1/19/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//  use CACHE to store images and concurrenly download them
//

import UIKit
import SDWebImage

class BooksTableViewController: UITableViewController {
    
    //var cache = NSCache<AnyObject, AnyObject>()
    var resultList : [String]?
    var bookList: [Book]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        if (resultList?.count)! < 1 {
            print("ERROR: The BooksTableViewController got an empty result list! ")
            return
        }else{
            //for s in resultList!{
            //    print(">>>>>  \(s)")
            //}
        
            
            bookList = makeBookList(stringsOfBooks: resultList!)
        }
        
        //do nothing if something went wrong and the list is empty
        
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if resultList == nil {
            return 0
        }else{
            return resultList!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if resultList == nil{
            return UITableViewCell()
        }else{
            let mycell = tableView.dequeueReusableCell(withIdentifier: "BooksCell", for: indexPath) as! BooksCell
            mycell.bookTitle.text = bookList?[indexPath.row].title
            mycell.bookText?.text = bookList?[indexPath.row].infos()
            print("textLabel: \n\(mycell.textLabel?.text)")
            
            if let url = URL(string: bookList![indexPath.row].imageURL!){
                mycell.bookCover.sd_setImage(with: url)
            }else{
                print("Not able to set image for index \(indexPath.row)")
            }
            
            
            
            
//            if let img = cache.object(forKey: indexPath.row as AnyObject) {
//                mycell.bookCover.image = img as? UIImage
//            }else {
//                DispatchQueue.global().async {
//                    let url: String = (self.bookList?[indexPath.row].imageURL)!
//                    let data = NSData(contentsOf: URL(string: url)!)
//                    DispatchQueue.main.async {
//                        mycell.bookCover.image = UIImage(data: data as! Data)
//                        self.cache.setObject(UIImage(data: data as! Data)!, forKey: indexPath.row as AnyObject)
//                        print("put up image ar \(indexPath.row)")
//                    }
//                }
//            }
            
            
            //print("  For book table cell at index \(indexPath.row), put:\n\(mycell.bookText.text)")
            return mycell
        }
    }
    
    private func makeBookList(stringsOfBooks: [String]) -> [Book] {
        var tempBookList = [Book]()
        for bookString in stringsOfBooks{
            tempBookList.append(Book(allInfoAboutBook: bookString))
            
        }
        return tempBookList
    }

   

}
