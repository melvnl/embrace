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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myPostTableView.delegate = self
        self.myPostTableView.dataSource = self
        
        self.myPostTableView.rowHeight = 497.0
        
        self.myPostTableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "forumCellID")
        
        fetchForumData()
    }
    
}

extension MyPostViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forumSection = forums[indexPath.section]
        let cell = myPostTableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
        
        cell.categoryForum.setTitle(forumSection.category, for: .normal)
        cell.dateForum.text = forumSection.date.toString("MMM d, yyyy")
        cell.titleForum.text = forumSection.forumTitle
        cell.descForum.text = forumSection.forumDesc
        
        let forumImgUrl = URL(string: forumSection.forumThumbnail)!
        cell.imgForum.load(url: forumImgUrl)
        
        let authorImgUrl = URL(string: forumSection.authorAvatar)!
        cell.authorImg.load(url: authorImgUrl)
        
        cell.authorName.text = forumSection.authorName
        cell.authorUsername.text = "@" + forumSection.authorUsername
        
        return cell
    }

    func fetchForumData() {
        
        var newEntries : [EntryForum] = []
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            self.showSpinner(onView: self.view)
            forumRepo.fetchUserThreads { entryList in
                newEntries = entryList
                print(entryList)
                group.leave()
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
