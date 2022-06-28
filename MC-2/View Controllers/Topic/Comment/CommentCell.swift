//
//  CommentCell.swift
//  MC-2
//
//  Created by melvin on 28/06/22.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var forumId = ""
    
}
