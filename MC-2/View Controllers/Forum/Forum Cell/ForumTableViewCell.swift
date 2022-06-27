//
//  ForumTableViewCell.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 22/06/22.
//

import UIKit

class ForumTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryForum: UIButton!
    @IBOutlet weak var dateForum: UILabel!
    @IBOutlet weak var titleForum: UILabel!
    @IBOutlet weak var descForum: UITextView!
    @IBOutlet weak var imgForum: UIImageView!
    @IBOutlet weak var authorImg: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorUsername: UILabel!
    @IBOutlet weak var commentForum: UIButton!
    @IBOutlet weak var savedForum: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryForum.layer.cornerRadius = 18
        categoryForum.clipsToBounds = true
        
        authorImg.layer.masksToBounds = false
        authorImg.layer.cornerRadius = authorImg.frame.height / 2
        authorImg.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
