//
//  LoginViewController.swift
//  
//
//  Created by user on 14/01/16.
//
//

import UIKit


protocol LoginViewControllerDelegate {
    func controller(controller: LoginViewController, apiManager: RestAPIManager, issues: [IssuesListItem], isUserLoggedIn: Bool)
}

//

//var g_RAMgr: RestApiManager

class LoginViewController: UIViewController {
    var delegate: LoginViewControllerDelegate! = nil
    var issuesAfterLogin: [IssuesListItem] = [IssuesListItem]()
    var isUserLgdIn: Bool = false
    var apiMgr: RestAPIManager! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.LoginVerificationIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var LoginVerificationIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userNameText: UITextField!

    @IBOutlet weak var userPwdText: UITextField!
    
    @IBOutlet weak var jiraURLText: UITextField!
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        self.LoginVerificationIndicator.startAnimating()
        
        var userName = userNameText.text!
        var userPwd = userPwdText.text!
        var baseUrl = jiraURLText.text!
        
        //REMOVE IT
        userName = "pbaranwal@realization.com"
        userPwd = "pbaranwal1$"
        baseUrl = "https://realization.atlassian.net"
        
        if(userName.isEmpty || userPwd.isEmpty || baseUrl.isEmpty){
            displayCustomAlertMessage("All the fields are required!")
            return;
        }
        
        self.apiMgr = RestAPIManager(uName: userName, uPwd: userPwd, bUrl: baseUrl)
        self.apiMgr.getIssuesList(OnIssueListReceived)
        
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(userPwd, forKey: "password")
        NSUserDefaults.standardUserDefaults().setObject(baseUrl, forKey: "baseurl")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func OnIssueListReceived(messageStr: String, issuesList: [IssuesListItem]){
        
        self.issuesAfterLogin = issuesList
        self.isUserLgdIn = true;
        
        dispatch_async(dispatch_get_main_queue(), {
            let customAlert = UIAlertController(title: "Alert", message: messageStr, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default){ action in
                self.dismissViewControllerAnimated(true, completion: nil)
                
                self.createIssuesNavigationController()
            }
            customAlert.addAction(okAction)
            self.presentViewController(customAlert, animated: true, completion: nil)
        });

    }
    
    func displayCustomAlertMessage(msg: String){
        let customAlert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
        
        customAlert.addAction(okAction)
        
        self.LoginVerificationIndicator.stopAnimating()
        self.presentViewController(customAlert, animated: true, completion: nil)
    }
    
    func createIssuesNavigationController(){
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let issuesController = sb.instantiateViewControllerWithIdentifier("issueListController") as! ViewController
        issuesController.issuesList = self.issuesAfterLogin
        issuesController.isUserLoggedIn = self.isUserLgdIn
        issuesController.apiMgr = self.apiMgr
        
        let rearvController = sb.instantiateViewControllerWithIdentifier("rearController") as! SideMenuViewController
        
        let navController = UINavigationController(rootViewController: issuesController)
        let swrvController = SWRevealViewController(rearViewController: rearvController, frontViewController: navController)
        //swrvController.delegate = self
        
        appDelegate.window!.rootViewController = swrvController
        appDelegate.window!.makeKeyAndVisible()
    }
}
