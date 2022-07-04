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
    
    var currUser: ProfileEntry?
    
    var categoriesDetail : [EntryForum] = []
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCurrentUser()
        fetchForumData()
    }
    
    func fetchForumData() {
        
        var newEntries : [EntryForum] = []
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            self.showSpinner(onView: self.view)
            forumRepo.fetchAllThreads { entryList in
                newEntries = entryList
                group.leave()
            }
        }
        
        group.notify(queue: .main){ [self] in
            removeSpinner()
            
            categoriesDetail = newEntries
            
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        }
        
    }
    
    func fetchCurrentUser(){
        profileRepo.fetchCurrentUser{ currUser in
            self.currUser = currUser
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
           print("section: \(indexPath.section)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let detail = categoriesDetail[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
        
        cell.threadID = detail.id
        cell.categoryForum.setTitle(detail.category, for: .normal)
        cell.categoryForum.setCategoryColor(detail.category)
        cell.dateForum.text = detail.date.toString("MMM d, yyyy")
        cell.titleForum.text = detail.forumTitle
        cell.descForum.text = detail.forumDesc
        cell.commentForum.threadID = detail.id
        cell.commentForum.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
        cell.commentForum.setTitle(String(detail.count), for: .normal)
        cell.commentForum.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        if(detail.forumThumbnail == EMPTY_IMAGE){
            cell.imgForum.isHidden = true
        }
        
        let forumImgUrl = URL(string: detail.forumThumbnail)!
        cell.imgForum.load(url: forumImgUrl)
        
        let authorImgUrl = URL(string: detail.authorAvatar)!
        cell.authorImg.load(url: authorImgUrl)
        
        cell.authorName.text = detail.authorName
        cell.authorUsername.text = "@" + detail.authorUsername
        
        if(currUser!.saves.contains(cell.threadID!)){
            cell.isSaved = true
            cell.setSavedStateImage()
        }
        
        return cell
    }
    
    @objc func segueToNextView(_ sender: CommentButton){
        let sb = UIStoryboard(name: "CommentStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CommentController") as! CommentController
        vc.forumId = sender.threadID!
        present(vc, animated: true)
    }
    
    
}
