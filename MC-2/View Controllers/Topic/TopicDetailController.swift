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

        tableView.register(UINib(nibName: "TableDetailCell", bundle: nil), forCellReuseIdentifier: "topicDetailCellId")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 497
        
        topicTitle.text = categorySub;
        
        // header
        // ini jangan di apus dl yak
//        let docHeader = db.collection("forum").document(categoryDocId).getDocument { (docSnapshot, error) in
//            if let doc = docSnapshot {
//                let title = doc.get("category") as? String ?? ""
//                let desc = doc.get("desc") as? String ?? ""
//                let imgURL_ = URL(string: doc.get("bigThumbail") as? String ??  self.placeholderAvatar)!
//
//
//                self.headerTitle.text = title
//                self.topicTitle.text = title
//                self.headerDesc.text = desc
//                self.headerImg.load(url: imgURL_)
//            } else {
//                if let error = error {
//                    print(error)
//                }
//            }
//        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicDetailCellId", for: indexPath) as! TableDetailCell
        
        cell.comment.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
        
        cell.comment.setTitle("haha", for: .normal)
        
        //forum
        cell.forumTitle.text = detail.forumTitle
        cell.forumDesc.text = detail.desc
        cell.date.text = detail.date.toString("MMM d, yyyy")
        let forumImgUrl = URL(string: detail.thumbnail )!
        cell.forumThumbnail.load(url: forumImgUrl)
        cell.forumThumbnail.layer.cornerRadius = 10
        cell.forumThumbnail.layer.masksToBounds = true
        cell.categoryTitle.setTitle(detail.categoryTitle, for: .normal)

        //avatar
        cell.accName.text = detail.accName
        cell.accUsername.text = detail.accUsername
        let imgUrl = URL(string: detail.accAvatar )!
        cell.accAvatar.load(url: imgUrl)
        cell.accAvatar.layer.cornerRadius = cell.accAvatar.frame.height / 2
        cell.accAvatar.clipsToBounds = true
        cell.forumId = detail.id
        
        cell.categoryTitle.layer.cornerRadius = 20
        cell.categoryTitle.setCategoryColor(categorySub);
        return cell
    }
    
    
}
