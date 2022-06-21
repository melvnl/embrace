//
//  ProfileViewController.swift
//  MC-2
//
//  Created by Vendly on 13/06/22.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profileDesc: UITextView!
    @IBOutlet weak var profileSection: UISegmentedControl!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    @IBOutlet weak var segmentBtn: UISegmentedControl!
    
    let placeholderAvatar: String =  "https://firebasestorage.googleapis.com/v0/b/embrace-mini-challenge-2.appspot.com/o/avatar.png?alt=media&token=228d6d5e-53b2-461d-886f-90889981a393"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileSection.backgroundColor = .clear
        profileSection.tintColor = .clear

        profileSection.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: ".SFProText-Medium", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)

        profileSection.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: ".SFProText-Semibold", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.TSPrimary], for: .selected)
        
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = profileImg.frame.size.height / 2
        profileImg.clipsToBounds = true
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                let name = doc.get("nama") as? String ?? ""
                let username = doc.get("username") as? String ?? ""
                let imgURL_ = URL(string: doc.get("avatar") as? String ??  self.placeholderAvatar)!
                let description =  doc.get("description") as? String ?? ""
                
                self.nameLbl.text = name
                self.usernameLbl.text = "@\(username)"
                self.profileImg.load(url: imgURL_)
                self.profileDesc.text = description
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
        
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIColor {
    @nonobjc class var TSPrimary: UIColor {
        return UIColor(red:0.85, green:0.11, blue:0.38, alpha:1.0)
    }
}
