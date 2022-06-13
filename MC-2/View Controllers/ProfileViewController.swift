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
    
    var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                Firestore.firestore().collection("users").document(uid).getDocument { (docSnapshot, error) in
                    if let doc = docSnapshot {
//                        username = doc.get("username") as? String
//                        print("test", username)
                    } else {
                        if let error = error {
                            print(error)
                        }
                    }
                }
            }
    }
    
