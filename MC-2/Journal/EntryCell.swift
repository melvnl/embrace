import Foundation
import UIKit

enum mood {
    
}

class EntryCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        self.contentView.alpha = 0
        UIView.animate(withDuration: 1, animations: { self.contentView.alpha = 1 })
    }
}
