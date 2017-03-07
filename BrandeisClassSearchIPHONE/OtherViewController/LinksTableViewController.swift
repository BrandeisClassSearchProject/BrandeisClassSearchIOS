//
//  LinksTableViewController.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 12/25/16.
//  Copyright © 2016 Yuanze Hu. All rights reserved.
//

import UIKit

struct link {
    let title: String
    let url: String
    let subTitle: String
}


class LinksTableViewController: UITableViewController {
    
    let links: [link] = [
        link(title: "Brandeis Website", url: "http://www.brandeis.edu", subTitle: "www.brandeis.edu"),
        link(title: "University Bulletin", url: "https://www.brandeis.edu/registrar/bulletin/", subTitle: "Check your degree requirements"),
        link(title: "Sage", url: "https://www.brandeis.edu/sage/", subTitle: "Register classes and... tuition"),
        link(title: "Brandeis | Latte", url: "https://moodle2.brandeis.edu/", subTitle: "Course materials"),
        link(title: "Brandeis | Login", url: "https://login.brandeis.edu/", subTitle: "login.brandeis.edu"),
        link(title: "planDeis",url: "http://plandeis.com",subTitle:"Plan your courses\n(only accessible while on campus)")]
   
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinksTableCell", for: indexPath) as! LinksTableCell
        cell.title.text = links[indexPath.row].title
        cell.subTitle.text = links[indexPath.row].subTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: links[indexPath.row].url)!,options: [:], completionHandler: nil)
    }

}
