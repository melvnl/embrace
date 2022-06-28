//
//  MyPostViewController.swift
//  MC-2
//
//  Created by Vendly on 20/06/22.
//

import UIKit
import Firebase
import FirebaseAuth

class MyPostViewController: UIViewController {

    @IBOutlet weak var myPostTableView: UITableView!
    
    var forums: [EntryForum] = []
    var currUser: ProfileEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myPostTableView.delegate = self
        self.myPostTableView.dataSource = self

        self.myPostTableView.estimatedRowHeight = 497.0
        self.myPostTableView.rowHeight = UITableView.automaticDimension
        self.myPostTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.myPostTableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "forumCellID")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchForumData()
    }
    
}

extension MyPostViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.forums.count
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
        
        let forumSection = forums[(indexPath as NSIndexPath).section]

        let cell = myPostTableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
        
        cell.threadID = forumSection.id
        cell.categoryForum.setTitle(forumSection.category, for: .normal)
        cell.categoryForum.setCategoryColor(forumSection.category)
        cell.dateForum.text = forumSection.date.toString("MMM d, yyyy")
        cell.titleForum.text = forumSection.forumTitle
        cell.descForum.text = forumSection.forumDesc
        
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
            self.showSpinner(onView: self.view)
            profileRepo.fetchCurrentUser{ currUser in
                self.currUser = currUser
                forumRepo.fetchUserThreads { entryList in
                    newEntries = entryList
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main){ [self] in
            removeSpinner()
            
            if(newEntries == forums){
                return
            }
            
            forums = newEntries
            
            myPostTableView.dataSource = self
            myPostTableView.delegate = self
            myPostTableView.reloadData()
        }
        
    }
    
}
