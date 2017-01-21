
//  Created by Yuanze Hu on 12/22/16.
//  
//  This class handles all the navigation actions

import UIKit
import MMDrawerController


class LeftSideViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{

    var menuItems:[String] = ["Class Search","My Classes","My Schedule","Links"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad in LeftSideViewController")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCell(withIdentifier: "LeftSideTableCell", for: indexPath) as! LeftSideTableViewCell
        mycell.LeftSideMenuLabel.text = menuItems[indexPath.row]
        return mycell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0 :
            print("Switch to search")
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "center") as! ViewController
            doSwitch(SomeViewController: centerViewController)
            break;
            
        case 1 :
            print("Switch to My Classes")
            let classesViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyClass") as! MyClassesViewController
            doSwitch(SomeViewController: classesViewController)
            break;
        case 2 :
            print("Switch to Schedule")
            let scheduleViewController = self.storyboard?.instantiateViewController(withIdentifier: "MySchedule") as! MyScheduleViewController
            doSwitch(SomeViewController: scheduleViewController)
            break;
        case 3 :
            print("Switch to Links")
            let linksViewController = self.storyboard?.instantiateViewController(withIdentifier: "LinksTable") as! LinksTableViewController
            doSwitch(SomeViewController: linksViewController)
            break;
        default:
            print("default")
        }
        
        
        
        
    }
    
    //A helper func
    func doSwitch(SomeViewController: UIViewController ){
        let centerNavController = UINavigationController(rootViewController: SomeViewController)
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.centerContainer!.centerViewController = centerNavController
        appDel.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion:nil)
    }
}
