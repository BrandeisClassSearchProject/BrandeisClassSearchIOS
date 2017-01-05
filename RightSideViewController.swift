
//  Created by Yuanze Hu on 12/22/16.
//
//  This class handles all the navigation actions

import UIKit



class RightSideViewController: UITableViewController{
    
    var suggestions: [String] = []
    var searchController: UISearchController!
    var resultController = UITableViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad in RightSideViewController")
        self.hideKeyboardWhenTappedAround()
//        self.searchController = UISearchController(searchResultsController: resultController)
//        
//        self.tableView.tableHeaderView = self.searchController.searchBar
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if suggestions.count > 8 {
            return 8
        }else {
            return suggestions.count
        }
    }
    
//    override func application{
//        
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.suggestions[indexPath.row]
        return cell
    }
 

        
        
    
    
    
   
}
