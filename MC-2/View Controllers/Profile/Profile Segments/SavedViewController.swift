//
//  SavedViewController.swift
//  MC-2
//
//  Created by Vendly on 20/06/22.
//

import UIKit

class SavedViewController: UIViewController {

    @IBOutlet weak var savedTableView: UITableView!

    var savedForums: [EntryForum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.savedTableView.delegate = self
        self.savedTableView.dataSource = self
        
        self.savedTableView.rowHeight = 497.0
        
        self.savedTableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "forumCellID")
        
        fetchForumData()
    }

}

extension SavedViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedForums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forumSection = savedForums[indexPath.section]
        let cell = savedTableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
        
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
            //saved and delete threads (on progress)
            forumRepo.fetchUserThreads { entryList in
                newEntries = entryList
                print(entryList)
                group.leave()
            }
        }

        group.notify(queue: .main){ [self] in
            removeSpinner()

            if(newEntries == savedForums){
                return
            }

            savedForums = newEntries

            savedTableView.dataSource = self
            savedTableView.delegate = self
            savedTableView.reloadData()
        }

    }

}
