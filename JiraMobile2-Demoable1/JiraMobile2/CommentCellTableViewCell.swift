//
//  CommentCellTableViewCell.swift
//  JiraMobile2
//
//  Created by user on 11/02/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class CommentCellTableViewCell: UITableViewCell {

    @IBOutlet weak var CommentsBodyLbl: UILabel!
    
    
    @IBOutlet weak var LastUpdstedDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CommentsBodyLbl.sizeToFit() 
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
