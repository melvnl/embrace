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
    
    let db = Firestore.firestore()
    var comment : [Comment] = []
    let userID = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    let placeholderAvatar: String =  "https://firebasestorage.googleapis.com/v0/b/embrace-mini-challenge-2.appspot.com/o/avatar.png?alt=media&token=228d6d5e-53b2-461d-886f-90889981a393"
    
    @IBOutlet weak var currentUserAvatar: UIImageView!
    
    var currUser: ProfileEntry?
    var forumId: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.separatorColor = UIColor.clear
        
        table.estimatedRowHeight = 200
        table.rowHeight = UITableView.automaticDimension
    
        self.table.tableFooterView = UIView.init(frame: .zero)
        
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
        fetchUser()
    }
    
    func fetchUser(){
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.main.async {
            profileRepo.fetchCurrentUser{ currUser in
                self.currUser = currUser
                group.leave()
            }
        }
        
        group.notify(queue: .main){ [self] in
            let imgUrl = URL(string: currUser!.avatar ?? DEFAULT_AVATAR )!
            currentUserAvatar.load(url: imgUrl)
            currentUserAvatar.layer.cornerRadius = currentUserAvatar.frame.height/2
            currentUserAvatar.clipsToBounds = true
        }
        
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postComment(_ sender: Any) {
        
        let commentValue = textField.text
        fs.db.collection("comments").addDocument(data: [
            "forumId": forumId,
            "value": commentValue,
            "authorName": currUser?.name,
            "authorUsername": currUser?.username,
            "authorAvatar": currUser?.avatar,
        ])
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        
        cell.forumId = comments.forumId
        cell.name.text = comments.name
        cell.username.text = comments.username
        cell.value.text = comments.value
        
        
        let imgUrl = URL(string: comments.avatar )!
        cell.avatar.load(url: imgUrl)
        
        cell.avatar.layer.cornerRadius = 15
        cell.avatar.clipsToBounds = true
    
        return cell
    }
}
