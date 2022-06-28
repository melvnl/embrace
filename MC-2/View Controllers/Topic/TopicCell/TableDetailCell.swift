//
//  TableDetailCell.swift
//  MC-2
//
//  Created by melvin on 24/06/22.
//

import UIKit

class TableDetailCell: UITableViewCell {
    
    @IBOutlet weak var forumThumbnail: UIImageView!
    @IBOutlet weak var forumDesc: UITextView!
    @IBOutlet weak var forumTitle: UILabel!
    @IBOutlet weak var categoryTitle: UIButton!
    @IBOutlet weak var date: UILabel!
    
    
    @IBOutlet weak var accAvatar: UIImageView!
    @IBOutlet weak var accName: UILabel!
    
    @IBOutlet weak var accUsername: UILabel!
    @IBOutlet weak var comment: UIButton!
    
    var forumId: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "" {
           guard let secondViewController = segue.destination as? CommentController else { return }
        
           secondViewController.forumId = forumId
       }
    }
    
    func goToCommentDetail(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
