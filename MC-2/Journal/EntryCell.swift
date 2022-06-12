import Foundation
import UIKit

enum mood {
    
}

class EntryCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet private weak var moodImage: UIImageView!

    func setMoodImage(_ mood: Int){
        switch (mood){
        case MOOD_VHAPPY:
            moodImage.image = UIImage(systemName: "face.smiling")
            break;
        case MOOD_HAPPY:
            moodImage.image = UIImage(named: "face.smiling")
            break;
        case MOOD_NORMAL:
            moodImage.image = UIImage(named: "face.dashed")
            break;
        case MOOD_SAD:
            moodImage.image = UIImage(named: "face.smiling")
            break;
        case MOOD_VSAD:
            moodImage.image = UIImage(named: "face.smiling")
            break;
        default: break;
        }
    }
    
}
