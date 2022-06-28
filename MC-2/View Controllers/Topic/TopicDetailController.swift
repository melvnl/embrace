//
//  TopicDetailController.swift
//  MC-2
//
//  Created by melvin on 20/06/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class TopicDetailController: UIViewController {
    
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerDesc: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    let placeholderAvatar: String =  "https://firebasestorage.googleapis.com/v0/b/embrace-mini-challenge-2.appspot.com/o/avatar.png?alt=media&token=228d6d5e-53b2-461d-886f-90889981a393"
    
    var categoriesDetail : [CategoriesDetail] = []
    
    var categoryDocId: String = "";
    var categoryTitle: String = "";
    var categorySub: String = "";
    
    let db = Firestore.firestore()
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear

        tableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "forumCellID")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 497
        
        topicTitle.text = categorySub;
        
        //detail
        print("test")
        print(categoryDocId)
        let docRef = db.collection("forums")
        docRef.whereField("category", isEqualTo: categoryDocId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                    for document in querySnapshot!.documents {
                        

                        let currEntry = CategoriesDetail(
                            id: document.documentID,
                            categoryTitle: document.get("category")! as! String,
                            forumTitle: document.get("forumTitle")! as! String,
                            thumbnail: document.get("forumThumbnail") as? String ?? "",
                            desc: document.get("forumDesc")! as! String,
                            date: (document.get("date")! as! Timestamp).dateValue(),
                            accName: document.get("authorName")! as! String,
                            accUsername: document.get("authorUsername")! as! String,
                            accAvatar: document.get("authorAvatar")! as! String
                        )
                        self.categoriesDetail.append(currEntry)
                    }
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()

                print(self.categoriesDetail);
            }
            }
    }
}

extension TopicDetailController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoriesDetail.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = 1

        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 497;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //buat post comment
//        db.collection("forums").document("mhF1O5Nt8eacumykpO8Q").collection("comment").addDocument(data: ["Avatar":"123"])
           print("section: \(indexPath.section)")
          
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let detail = categoriesDetail[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
        
        cell.commentForum.threadID = detail.id
        cell.commentForum.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
        
        //forum
        cell.titleForum.text = detail.forumTitle
        cell.descForum.text = detail.desc
        cell.dateForum.text = detail.date.toString("MMM d, yyyy")
        let forumImgUrl = URL(string: detail.thumbnail )!
        cell.imgForum.load(url: forumImgUrl)
        cell.categoryForum.setTitle(detail.categoryTitle, for: .normal)

        //avatar
        cell.authorName.text = detail.accName
        cell.authorUsername.text = detail.accUsername
        let imgUrl = URL(string: detail.accAvatar )!
        cell.authorImg.load(url: imgUrl)
        cell.threadId = detail.id
        
        cell.categoryForum.setCategoryColor(detail.categoryTitle);
        return cell
    }
    
    @objc func segueToNextView(_ sender: CommentButton){
        let sb = UIStoryboard(name: "CommentStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CommentController") as! CommentController
        vc.forumId = sender.threadID!
        present(vc, animated: true)
    }
    
    
}
