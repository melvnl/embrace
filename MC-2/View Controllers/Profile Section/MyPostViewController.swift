//
//  MyPostViewController.swift
//  MC-2
//
//  Created by Vendly on 27/06/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MyPostViewController: UIViewController {

    @IBOutlet weak var myPostTableView: UITableView!
    
    let db = Firestore.firestore()
    var myPostModel : [Forum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

<<<<<<< Updated upstream
=======
        self.myPostTableView.rowHeight = 497.0
        
        self.myPostTableView.delegate = self
        self.myPostTableView.dataSource = self

        self.myPostTableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "forumCellID")
        
        let docRef = db.collection("forum").document("9nc6jyqsNkEiYWALSaFB").collection("kehamilan")

        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    for document in querySnapshot!.documents {
                        let currEntry = Forum(
                            title: document.get("title") as! String,
                            name: document.get("authorName")! as! String,
                            username: document.get("authorUsername")! as! String,
                            desc: document.get("desc")! as! String,
                            category: document.get("categoryTitle")! as! String,
                            date: (document.get("date")! as! Timestamp).dateValue(),
                            image: document.get("thumbnail") as? String ?? "",
                            avatar: document.get("authorAvatar")! as! String
                        )
                        self.myPostModel.append(currEntry)
                    }
                self.myPostTableView.delegate = self
                self.myPostTableView.dataSource = self
                self.myPostTableView.reloadData()

            }
        }
        
    }

}

extension MyPostViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPostModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let forum = myPostModel[indexPath.section]
        let cell = myPostTableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
        
        cell.categoryBtn.setTitle(forum.category, for: .normal)
        
        cell.dateLbl.text = forum.date.toString("MMM d, yyyy")
        cell.titleLbl.text = forum.title
        cell.descLbl.text = forum.desc
        
        let imgURL = URL(string: forum.image)!
        cell.postImg.load(url: imgURL)
        
        let avatarURL = URL(string: forum.avatar)!
        cell.profileImg.load(url: avatarURL)
        
        cell.nameLbl.text = forum.name
        cell.usernameLbl.text = forum.username
        
        return cell
>>>>>>> Stashed changes
    }

    
    
    
}
