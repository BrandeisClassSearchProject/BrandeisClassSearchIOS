
//  Created by Yuanze Hu on 12/22/16.
//
//  This class handles all the navigation actions

import UIKit
import MMDrawerController


class RightSideViewController: UITableViewController, UISearchBarDelegate{
    
    var suggestions: [String] = []
    var searchController: UISearchController!
    var resultController = UITableViewController()
    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad in RightSideViewController")
        tableView.estimatedRowHeight = 65
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("switch to \n\(suggestions[indexPath.row])")
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.addHistory(newHistory: suggestions[indexPath.row])
        doSwitchCenter()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCell(withIdentifier: "RightSideTableViewCell", for: indexPath) as! RightSideTableViewCell
        let s: [String] = self.suggestions[indexPath.row].components(separatedBy: "\n")
        mycell.IdText.text = s[0]
        mycell.NameText.text=s[1]
        return mycell;

//        
//        
//        cell.textLabel?.text = self.suggestions[indexPath.row]
//        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText as NSString).length > 2 || searchText.uppercased()=="FA" || searchText.uppercased()=="PE" || searchText.uppercased()=="HS" || searchText.uppercased()=="ED"{
            print("search for" + searchText)
            
            suggestions = appDel.courseDictionary!.suggestions(courseID: searchText)
            var s: String=""
            for strings in suggestions{
                s = s+strings+"\n"
            }
            print("suggestions:\n\(s)")
            self.tableView.reloadData()
        }else  {
            suggestions = [] //replace with history later 
            self.tableView.reloadData()

        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        if suggestions.count > 0 {
            doSwitchCenter()
        }
        
        
    }
 
    func doSwitchCenter(){
        view.endEditing(true)
        let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "center") as! ViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
     
        appDel.centerContainer!.centerViewController = centerNavController
        appDel.centerContainer!.toggle(MMDrawerSide.right, animated: true, completion:nil)
    }
        
        
    
    
    
   
}
