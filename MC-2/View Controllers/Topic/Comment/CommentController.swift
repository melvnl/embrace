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
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var currentUserAvatar: UIImageView!

    var comments : [Comment] = []
    let userID = Auth.auth().currentUser!.uid
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
        
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        postButton.isEnabled = false
        
        loadComments()
        profileRepo.fetchCurrentUser{ [self] currUser in
            self.currUser = currUser
            let imgUrl = URL(string: currUser.avatar)!
            currentUserAvatar.load(url: imgUrl)
            currentUserAvatar.layer.cornerRadius = 20
            currentUserAvatar.clipsToBounds = true
        }
    }
    
    func loadComments(){
        comments.removeAll()
        commentRepo.fetchComments(forumId){ [self] comments in
            self.comments = comments
            self.table.delegate = self
            self.table.dataSource = self
            self.table.reloadData()
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postComment(_ sender: Any) {
        
        let newComment = Comment(
            forumId: forumId,
            avatar: currUser!.avatar,
            username: currUser!.username,
            name: currUser!.name,
            value: textField.text!,
            date: Date.now
        )
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async{
            commentRepo.createComment(newComment){ success in
                group.leave()
            }
        }
        
        group.notify(queue: .main){ [self] in
            textField.text = ""
            postButton.isEnabled = false
            loadComments()
        }
        
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if (textField.text == ""){
            postButton.isEnabled = false
        }
        else{
            postButton.isEnabled = true
        }
    }
}

extension CommentController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
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
        
        let comments = comments[indexPath.section]
        let cell = table.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        cell.forumId = comments.forumId
        cell.name.text = comments.name
        cell.username.text = comments.username
        cell.value.text = comments.value
        
        let imgUrl = URL(string: comments.avatar )!
        cell.avatar.load(url: imgUrl)
    
        return cell
    }
}
