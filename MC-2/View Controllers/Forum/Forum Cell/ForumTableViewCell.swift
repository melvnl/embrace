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
    @IBOutlet weak var commentForum: CommentButton!
    @IBOutlet weak var savedForum: UIButton!
    var threadID : String?
    var isSaved : Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        isSaved = false
        
        setSavedStateImage()
        
        categoryForum.isUserInteractionEnabled = false
        categoryForum.layer.cornerRadius = 14
        categoryForum.clipsToBounds = true

        descForum.isScrollEnabled = false
        descForum.sizeToFit()
        
        authorImg.layer.masksToBounds = false
        authorImg.layer.cornerRadius = 20
        authorImg.clipsToBounds = true
        
        imgForum.layer.cornerRadius = 10
        imgForum.layer.masksToBounds = true
        
        self.contentView.alpha = 0
        UIView.animate(withDuration: 1, animations: { self.contentView.alpha = 1 })        
    }

    func setSavedStateImage(){
        if(isSaved!){
            savedForum.setImage(UIImage(systemName:"bookmark.fill"), for: .normal)
        }
        else {
            savedForum.setImage(UIImage(systemName:"bookmark"), for: .normal)
        }
    }
    
    @IBAction func didTapSaveThread(_ sender: Any) {
        if(isSaved!){
            forumRepo.deleteSavedThread(threadID!)
            isSaved = false
        }
        else{
            forumRepo.saveThread(threadID!)
            isSaved = true
        }
        
        setSavedStateImage()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
