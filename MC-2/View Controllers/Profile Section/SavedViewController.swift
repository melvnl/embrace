//
//  SavedViewController.swift
//  MC-2
//
//  Created by Vendly on 20/06/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SavedViewController: UIViewController {

    @IBOutlet weak var savedTableView: UITableView!
    
    let db = Firestore.firestore()
    var savedModel : [Forum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

<<<<<<< Updated upstream
=======
        self.savedTableView.rowHeight = 497.0
        
        self.savedTableView.delegate = self
        self.savedTableView.dataSource = self
        
        self.savedTableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "forumCellID")
        
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
                        self.savedModel.append(currEntry)
                    }
                self.savedTableView.delegate = self
                self.savedTableView.dataSource = self
                self.savedTableView.reloadData()

            }
        }
        
>>>>>>> Stashed changes
    }

    

}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let forum = savedModel[indexPath.section]
        let cell = savedTableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
        
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
    }
    
    
}
