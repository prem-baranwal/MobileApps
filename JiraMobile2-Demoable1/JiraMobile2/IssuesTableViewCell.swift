//
//  IssuesTableViewCell.swift
//  JiraMobile2
//
//  Created by user on 31/01/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class IssuesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var issueID: UILabel!
    
    @IBOutlet weak var issueDesc: UILabel!
    
    
    @IBOutlet weak var issueType: UIImageView!
    
    @IBOutlet weak var issuePriority: UIImageView!
    
    @IBOutlet weak var updatedDate: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
