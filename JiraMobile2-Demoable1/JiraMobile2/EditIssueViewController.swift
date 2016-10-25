//
//  EditIssueViewController.swift
//  JiraMobile2
//
//  Created by user on 02/02/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class EditIssueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnCancelButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func OnDoneButtonTapped(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }


}
