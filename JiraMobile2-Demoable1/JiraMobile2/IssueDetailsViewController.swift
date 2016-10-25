//
//  IssueDetailsViewController.swift
//  JiraMobile2
//
//  Created by user on 02/02/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class IssueDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let parseDateFormatter = NSDateFormatter()
    let displayDateFormatter = NSDateFormatter()
    
    var issueDetails: IssuesListItem!
    var apiMgr: RestAPIManager!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var IssueKeyLbl: UILabel!
    
    @IBOutlet weak var IssueSummaryLbl: UILabel!
    
    @IBOutlet weak var AssigneeLbl: UILabel!
    
    @IBOutlet weak var StatusLbl: UILabel!
    
    @IBOutlet weak var IssueTypeLbl: UILabel!
    
    @IBOutlet weak var PriorityLbl: UILabel!
    
    @IBOutlet weak var FixVersionsLbl: UILabel!
    
    @IBOutlet weak var ReporterLbl: UILabel!
    
    @IBOutlet weak var CreatedDateLbl: UILabel!
    
    @IBOutlet weak var LastUpdatedDateLbl: UILabel!
    
    @IBOutlet weak var DescriptionLbl: UILabel!
    
    @IBOutlet weak var CommentBox: UITextField!
    
    @IBOutlet weak var CommentsTableView: UITableView!
    
    @IBAction func OnCommentAddTapped(sender: AnyObject) {
        apiMgr.addCommentForIssue(issueDetails, commentStr: CommentBox.text!, addCommentHandler: onAddCommentSuccessful)
    }
    
    func onAddCommentSuccessful(addedComment: Comment!){
        if (addedComment != nil){
            issueDetails.comments.append(addedComment)
            self.CommentsTableView.reloadData()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.CommentBox.text = ""
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        displayDateFormatter.dateFormat = "E, MMM dd h:m a"
        parseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ScrollView.contentSize.height = 1000
        IssueKeyLbl.text = issueDetails.issueKey
        IssueSummaryLbl.text = issueDetails.summary
        AssigneeLbl.text = issueDetails.assignee
        StatusLbl.text = issueDetails.status
        IssueTypeLbl.text = issueDetails.issueType
        PriorityLbl.text = issueDetails.priority
        
        ReporterLbl.text = issueDetails.reporter
        let luDateObj = parseDateFormatter.dateFromString(issueDetails.lastUpdatedDate!)
        LastUpdatedDateLbl.text = displayDateFormatter.stringFromDate(luDateObj!)
        
        DescriptionLbl.text = issueDetails.desc
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //CommentsTableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let commentCell = self.CommentsTableView.dequeueReusableCellWithIdentifier("comment") as! CommentCellTableViewCell
        
        let cellContent = self.issueDetails.comments[indexPath.row]
        commentCell.CommentsBodyLbl.text = cellContent.commentBody
        let luObj = parseDateFormatter.dateFromString(cellContent.commentUpdatedDate!)
        commentCell.LastUpdstedDateLbl.text = displayDateFormatter.stringFromDate(luObj!)
        
        return commentCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueDetails.comments.count;
    }
    

}
