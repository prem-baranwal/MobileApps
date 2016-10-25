//
//  JiraIssues.swift
//  JiraMobile2
//
//  Created by user on 24/01/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class IssuesListItem : NSObject{
    var issueKey: String?
    var issueType: String?
    var status: String?
    var assignee: String?
    var summary: String?
    var priority: String?
    var lastUpdatedDate: String?
    var desc: String?
    var comments: [Comment] = []
    var reporter: String?
    var project: String?
    var fixVersions: [String] = []
    var labels: [String] = []
    init(iKey: String, iSummary: String){
        super.init()
        
        issueKey = iKey
        summary = iSummary
    }
    
    init(JSONData: JSON) {
        super.init()
        
        issueKey = JSONData["key"].string
        issueType = JSONData["fields"]["issuetype"]["name"].string
        priority = JSONData["fields"]["priority"]["name"].string
        lastUpdatedDate = JSONData["fields"]["updated"].string
        status = JSONData["fields"]["status"]["name"].string
        summary = JSONData["fields"]["summary"].string
        assignee = JSONData["fields"]["assignee"]["displayName"].string
        if let descTemp = JSONData["fields"]["description"].string {
            desc = descTemp
        }else{
            desc = ""
        }
        reporter = JSONData["fields"]["reporter"]["displayName"].string
        project = JSONData["fields"]["project"]["name"].string
        for labelObj in JSONData["fields"]["labels"].arrayValue{
            labels.append(labelObj.stringValue)
        }
        for commentObj in JSONData["fields"]["comment"]["comments"].arrayValue{
            comments.append(Comment(JSONData: commentObj))
        }
    }
}

class Comment : NSObject{
    var commentAuthor: String?
    var commentBody: String?
    var commentUpdatedDate: String?
    init(JSONData: JSON) {
        super.init()
        
        commentAuthor = JSONData["updateAuthor"]["displayName"].string!
        commentBody = JSONData["body"].string!
        commentUpdatedDate = JSONData["updated"].string!
    }
}
