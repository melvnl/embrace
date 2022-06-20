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
        
        print("test")
        print(categoryTitle)
        print(categoryDocId)
        
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
