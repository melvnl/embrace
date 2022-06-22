//
//  TopicDetailController.swift
//  MC-2
//
//  Created by melvin on 20/06/22.
//

import Foundation
import UIKit
import Firebase

class TopicDetailController: UIViewController {
    
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerDesc: UILabel!
    
    let placeholderAvatar: String =  "https://firebasestorage.googleapis.com/v0/b/embrace-mini-challenge-2.appspot.com/o/avatar.png?alt=media&token=228d6d5e-53b2-461d-886f-90889981a393"
    
    var categoryDocId: String = "";
    var categoryTitle: String = "";
    var categorySub: String = "";
    
    let db = Firestore.firestore()
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        let TopicViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.topicViewController) as? TopicViewController
        
        self.view.window?.rootViewController = TopicViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topicTitle.text = categoryTitle;
        
        let docHeader = db.collection("forum").document(categoryDocId).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                let title = doc.get("category") as? String ?? ""
                let desc = doc.get("desc") as? String ?? ""
                let imgURL_ = URL(string: doc.get("bigThumbail") as? String ??  self.placeholderAvatar)!
    
                
                self.headerTitle.text = title
                self.topicTitle.text = title
                self.headerDesc.text = desc
                self.headerImg.load(url: imgURL_)
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
        
        let docRef = db.collection("forum").document(categoryDocId).collection(categorySub)
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    for document in querySnapshot!.documents {
                        
                        print(document.documentID)

//                        let currEntry = Categories(
//                            category: document.get("category")! as! String,
//                            thumbnail: document.get("thumbnail") as? String ?? "",
//                            desc: document.get("desc")! as! String
//                        )
//                        self.categories.append(currEntry)
                    }
//                self.table.delegate = self
//                self.table.dataSource = self
//                self.table.reloadData()
//
//                    print(self.categories);
            }
            }
    }


}
