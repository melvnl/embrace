//
//  CommentController.swift
//  MC-2
//
//  Created by melvin on 28/06/22.
//

import UIKit
import Firebase
import FirebaseAuth

class CommentController: UIViewController {

    
    @IBOutlet weak var table: UITableView!
//    @IBOutlet weak var username: UILabel!
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var value: UILabel!
//    @IBOutlet weak var avatar: UIImageView!
    
    let db = Firestore.firestore()
    var comment : [Comment] = []
    
    var forumId: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.separatorColor = UIColor.clear
    
        self.table.tableFooterView = UIView.init(frame: .zero)
        
        print(forumId)
        
        let docRef = db.collection("comments")
        
        docRef.whereField("forumId", isEqualTo: forumId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    for document in querySnapshot!.documents {

                let commentEntry = Comment(
                    forumId: document.get("forumId")! as! String,
                    avatar: document.get("authorAvatar") as? String ?? "",
                    username: document.get("authorUsername") as? String ?? "",
                    name: document.get("authorName") as? String ?? "",
                    value: document.get("value")! as! String
                )
                self.comment.append(commentEntry)
                }
                self.table.delegate = self
                self.table.dataSource = self
                self.table.reloadData()
            
                print(self.comment);
            }
            }

        // Do any additional setup after loading the view.
    }

}

extension CommentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return comment.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = 1
        
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("section: \(indexPath.section)")
          
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comments = comment[indexPath.section]
        let cell = table.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        table.layer.cornerRadius = 10
        
        cell.forumId = comments.forumId
        cell.name.text = comments.name
        cell.username.text = comments.username
        cell.value.text = comments.value
        
        
        let imgUrl = URL(string: comments.avatar )!
        cell.avatar.load(url: imgUrl)
    
        return cell
    }
}
