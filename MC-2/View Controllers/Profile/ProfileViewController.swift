//
//  ProfileViewController.swift
//  MC-2
//
//  Created by Vendly on 13/06/22.
//

import UIKit
import Firebase
import FirebaseAuth
import simd

class ProfileViewController: UIViewController {

    var profileUrl : String!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profileDesc: UITextView!
    @IBOutlet weak var profileSection: UISegmentedControl!
    
    let segmentindicator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.TSPrimary
        return v
    }()
    
    let imgURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/embrace-mini-challenge-2.appspot.com/o/avatar.png?alt=media&token=228d6d5e-53b2-461d-886f-90889981a393")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileSection.backgroundColor = .clear
        profileSection.tintColor = .clear

        profileSection.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: ".SFProText-Medium", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)

        profileSection.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: ".SFProText-Semibold", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.TSPrimary], for: .selected)
        
        self.view.addSubview(segmentindicator)
        
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = profileImg.frame.size.height / 2
        profileImg.clipsToBounds = true
        
        
        loadProfile()
    }
    
    @IBAction func didTapEdit(_ sender: Any) {
        profileRepo.fetchCurrentUser { [self] (currUser) -> Void in
            let user = ProfileEntry(
                username: currUser.username,
                name: currUser.name,
                description: currUser.description,
                avatar: currUser.avatar)
            
            guard let vc = (storyboard?.instantiateViewController(withIdentifier: "EditProfile") as? EditProfileViewController) else{
                return
            }
            
            vc.updateProfileCompletion = { newProfileEntry in
                profileRepo.updateProfile(uid: Auth.auth().currentUser!.uid, entry: newProfileEntry)
                self.navigationController?.popViewController(animated: true)
            }
            
            vc.currProfileEntry = user
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadProfile()
    }
    
    func loadProfile(){
        profileRepo.fetchCurrentUser { [self] (currUser) -> Void in
            nameLbl.text = currUser.name
            usernameLbl.text = "@" + currUser.username
            profileDesc.text = currUser.description
            profileImg.load(url: URL(string:currUser.avatar)!)
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
