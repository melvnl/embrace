//
//  SavedViewController.swift
//  MC-2
//
//  Created by Vendly on 20/06/22.
//

import UIKit
import Firebase
import FirebaseAuth

class SavedViewController: UIViewController {

    @IBOutlet weak var savedTableView: UITableView!

    var savedForums: [EntryForum] = []
    var currUser: ProfileEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.savedTableView.delegate = self
        self.savedTableView.dataSource = self
        
        self.savedTableView.estimatedRowHeight = 497.0
        self.savedTableView.rowHeight = UITableView.automaticDimension
        self.savedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.savedTableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "forumCellID")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Fetching saved data")
        fetchForumData()
    }
    

}

extension SavedViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.savedForums.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let forumSection = savedForums[(indexPath as NSIndexPath).section]
        let cell = savedTableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
        
        cell.threadID = forumSection.id
        cell.categoryForum.setTitle(forumSection.category, for: .normal)
        cell.categoryForum.setCategoryColor(forumSection.category)
        cell.dateForum.text = forumSection.date.toString("MMM d, yyyy")
        cell.titleForum.text = forumSection.forumTitle
        cell.descForum.text = forumSection.forumDesc
        cell.commentForum.threadID = forumSection.id
        cell.commentForum.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
        cell.commentForum.setTitle(String(forumSection.count), for: .normal)
        cell.commentForum.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        if(forumSection.forumThumbnail == EMPTY_IMAGE){
            cell.imgForum.isHidden = true
        }
        
        let forumImgUrl = URL(string: forumSection.forumThumbnail)!
        cell.imgForum.load(url: forumImgUrl)
        
        let authorImgUrl = URL(string: forumSection.authorAvatar)!
        cell.authorImg.load(url: authorImgUrl)
        
        cell.authorName.text = forumSection.authorName
        cell.authorUsername.text = "@" + forumSection.authorUsername
        
        if(currUser!.saves.contains(cell.threadID!)){
            cell.isSaved = true
            cell.setSavedStateImage()
        }
        
        return cell
        
    }
    
    func fetchForumData() {

        var newEntries : [EntryForum] = []
        let group = DispatchGroup()
        group.enter()

        DispatchQueue.main.async {
            profileRepo.fetchCurrentUser{ currUser in
                self.currUser = currUser
                forumRepo.fetchSavedThreads(currUser.saves) { entryList in
                    newEntries = entryList
                    group.leave()
                }
            }
            
        }

        group.notify(queue: .main){ [self] in
            if(newEntries == savedForums){
                return
            }
            savedForums = newEntries
            savedTableView.dataSource = self
            savedTableView.delegate = self
            savedTableView.reloadData()
        }

    }
    
    @objc func segueToNextView(_ sender: CommentButton){
        let sb = UIStoryboard(name: "CommentStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CommentController") as! CommentController
        vc.forumId = sender.threadID!
        present(vc, animated: true)
    }

}
