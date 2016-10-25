//
//  ViewController.swift
//  JiraMobile2
//
//  Created by user on 13/01/16.
//  Copyright (c) 2016 user. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, LoginViewControllerDelegate {
    
    var issuesList: [IssuesListItem] = [IssuesListItem]()
    var isUserLoggedIn = false
    var apiMgr: RestAPIManager!
    
    var tasklistLastUpdateDate = NSDate()
    
    @IBOutlet weak var isueListLoadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.isueListLoadingIndicator.stopAnimating()
        
        let image = UIImage(named: "menu_image.png")!.imageWithRenderingMode(.AlwaysOriginal)
        let MainMenuButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = MainMenuButton

        if (self.revealViewController() != nil) {
            MainMenuButton.target = self.revealViewController()
            MainMenuButton.action = Selector("revealToggle:")
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        let userPwd = NSUserDefaults.standardUserDefaults().stringForKey("password")
        let baseUrl = NSUserDefaults.standardUserDefaults().stringForKey("baseurl")
        let userName = NSUserDefaults.standardUserDefaults().stringForKey("username")
        if(userName == nil || userPwd == nil || baseUrl == nil){
            self.performSegueWithIdentifier("LoginView", sender: self)
        }
        else if (!self.isUserLoggedIn){
            self.isueListLoadingIndicator.startAnimating()
            apiMgr = RestAPIManager(uName: userName!, uPwd: userPwd!, bUrl: baseUrl!)
            apiMgr.getIssuesList(OnIssueListReceived)
        }
    }
    
    func OnIssueListReceived(messageStr: String, issues: [IssuesListItem]){
        
        self.issuesList = issues
        tasklistLastUpdateDate = NSDate()
        self.isUserLoggedIn = true
        
        dispatch_async(dispatch_get_main_queue(), {
            let customAlert = UIAlertController(title: "Alert", message: messageStr, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default){ action in
                self.tableView.reloadData()
                self.isueListLoadingIndicator.stopAnimating()
            }
            
            customAlert.addAction(okAction)
            
            self.presentViewController(customAlert, animated: true, completion: nil)
        });
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "IssueDetailsView"){
            let dest = segue.destinationViewController as! IssueDetailsViewController
            let rowIndex = (self.tableView.indexPathForSelectedRow?.row)!
            
            dest.issueDetails = issuesList[rowIndex]
            dest.apiMgr = apiMgr;
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let issueCellObj = tableView.dequeueReusableCellWithIdentifier("issueCell", forIndexPath: indexPath) as! IssuesTableViewCell
        issueCellObj.issueID.text = issuesList[indexPath.row].issueKey
        issueCellObj.issueDesc.text = issuesList[indexPath.row].summary
        issueCellObj.updatedDate.text = issuesList[indexPath.row].lastUpdatedDate
        
        return issueCellObj
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuesList.count
    }
    
    func controller(controller: LoginViewController, apiManager: RestAPIManager, issues: [IssuesListItem], isUserLoggedIn: Bool) {
        self.apiMgr = apiManager
        self.isUserLoggedIn = isUserLoggedIn
        self.issuesList = issues
    }
}

