//
//  RestAPIManager.swift
//  JiraMobile2
//
//  Created by user on 21/01/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import UIKit

typealias ServiceResponse = (JSON) -> Void
typealias IssueListResponseHandler = (String, issuesList: [IssuesListItem]) -> Void
typealias AddCommentResponseHandler = (addedComment: Comment) -> Void

class RestAPIManager: NSObject{
    
    var userName: String
    var userPwd: String
    var baseUrl: String
    var base64LoginData: String
    
    init(uName: String, uPwd: String, bUrl: String){
        self.userName = uName
        self.userPwd  = uPwd
        self.baseUrl = bUrl
        let loginString = NSString(format: "%@:%@", userName,userPwd)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        base64LoginData = loginData.base64EncodedStringWithOptions([])
    }
    
    func addCommentForIssue(issue: IssuesListItem, commentStr: String, addCommentHandler: AddCommentResponseHandler){
        
        let fullUrl = baseUrl + String(format: "/rest/api/2/issue/%@/comment", issue.issueKey!)
        
        let postDataDict = ["body": commentStr]
        let postDataJson = try! NSJSONSerialization.dataWithJSONObject(postDataDict, options: .PrettyPrinted)
        makeHTTPPostRequest(fullUrl, postData: postDataJson, onResponseReceived: { (json) -> Void in
            
            print(json.stringValue)
            addCommentHandler(addedComment: Comment(JSONData: json))
        })
    }
    
    func getIssuesList(issueListRespHandler: IssueListResponseHandler){
        
        let maxNoResults = 20, startAt = 0
        let resultsRangeClause = "&startAt=\(startAt)&maxResults=\(maxNoResults)"
        let fieldsRequired = "&fields=*navigable,description,comment"
        let orderByClause = "+ORDER+BY+updatedDate+DESC"
        let fullUrl = baseUrl + "/rest/api/2/search?jql=assignee='\(self.userName)'" + orderByClause + fieldsRequired + resultsRangeClause
        
        makeHTTPGetRequest(fullUrl, onResponseReceived: { (json) -> Void in
            var issues: [IssuesListItem]=[IssuesListItem]()
            
            let issuesArray = json["issues"]
            for issueJson in issuesArray.arrayValue{
                let issue = IssuesListItem(JSONData: issueJson)
                issues.append(issue)
            }
            
            issueListRespHandler(String(format:"Login Successful. Loading %2d issues.", issues.count), issuesList: issues)

        })
    }
    
    func getIssueDetails(){
        
    }
    
    func getFiltersAvailable(){
        
    }
    
    func getProjectsList(){
    
    }

    func makeHTTPPostRequest(fullPath: String, postData: NSData, onResponseReceived: ServiceResponse){
        let jiraUrl = NSURL(string: fullPath)
        let request = NSMutableURLRequest(URL: jiraUrl!)
        request.HTTPMethod = "POST"
        //request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = postData
        
        //basic authorization
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){(data, response, error) in
            if(error != nil){
                print("error:\(error)")
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let jsonData: JSON = JSON(data: data!, options: .MutableContainers)
            onResponseReceived(jsonData)
        }
        task.resume()
        
    }

    func makeHTTPGetRequest(fullPath: String, onResponseReceived: ServiceResponse){
        let jiraUrl = NSURL(string: fullPath)
        let request = NSMutableURLRequest(URL: jiraUrl!)
        request.HTTPMethod = "GET"
        
        //basic authorization
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){(data, response, error) in
            if(error != nil){
                print("error:\(error)")
                return
            }
            
            //let responseStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("\(responseStr)")
            
            let jsonData: JSON = JSON(data: data!, options: .MutableContainers)
            onResponseReceived(jsonData)
            
//            do{
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
//                if let parseJSON = json{
//                    //var firstName =  parseJSON["firstName"] as? String
//                    //print("firstName:\(firstName)")
//                }
//            }catch let error as NSError{
//                print("json error: \(error)")
//            }

            
//            var responseString:String = responseStr as String!
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                let customAlert = UIAlertController(title: "Alert", message: responseString, preferredStyle: UIAlertControllerStyle.Alert)
//                let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default){ action in
//                    //TODO uncomment below
//                    //self.dismissViewControllerAnimated(true, completion: nil)
//                }
//                
//                customAlert.addAction(okAction)
//                
//                //self.presentViewController(customAlert, animated: true, completion: nil)
//            });
            
            
            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "IsUserLoggedIn")
            //NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        task.resume()

    }
}