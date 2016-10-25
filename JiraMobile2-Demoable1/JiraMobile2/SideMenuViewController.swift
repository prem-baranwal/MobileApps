//
//  SideMenuViewController.swift
//  JiraMobile2
//
//  Created by user on 11/02/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
    
    var menuItems = [String]()
    
    
    
    override func viewDidLoad() {
                super.viewDidLoad()
        
        menuItems.append("Change Project")
        menuItems.append("Select Filter")
        menuItems.append("Logout")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let rowIndex = (self.tableView.indexPathForSelectedRow?.row)!
        
        
        if(segue.identifier == "sideMenu"){
            let dest = segue.destinationViewController as! ViewController
            if(rowIndex == 2){
                dest.isUserLoggedIn = false;
                dest.navigationController?.popToViewController(dest, animated: true)
            }
            else{
                dest.isUserLoggedIn = true
            }
        }
    }
    
    func MoveToLoginView(){
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            break
        case 1:
            break
        case 2:
            let navController = self.revealViewController().frontViewController as! UINavigationController
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = sb.instantiateInitialViewController() as! LoginViewController
            self.presentViewController(loginVC, animated: true, completion: nil)
            navController.popViewControllerAnimated(true)
            break
        default:
            break
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return menuItems.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->
        UITableViewCell {
        
            switch indexPath.section{
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("sideMenuHeaderCell", forIndexPath: indexPath) as! SideMenuUserViewCell
                //cell.textLabel!.text = menuItems[indexPath.row]
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("sideMenuItemCell", forIndexPath: indexPath) as! SideMenuItemCell
                cell.SideMenuItemLbl.text = menuItems[indexPath.row]
                return cell
            default:
                return UITableViewCell()
            }
    }

}
