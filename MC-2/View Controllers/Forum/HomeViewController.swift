//
//  HomeViewController.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 07/06/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UISearchBarDelegate{
    

    @IBOutlet weak var addNewForumButton: UIButton!
    
    @IBOutlet weak var forumSearchBar: UISearchBar!
    
    @IBOutlet weak var forumTableView: UITableView!
    
    var threads: [EntryForum] = []
    var filteredData: [EntryForum]!
    var isSearching = false
    var currUser: ProfileEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forumSearchBar.searchTextField.textColor = UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)
        forumSearchBar.searchTextField.attributedPlaceholder = NSAttributedString (
        string: "Cari apa saja yang Anda butuhkan...",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.32, green: 0.32, blue: 0.32, alpha: 1.00)])
        
        self.forumTableView.delegate = self
        self.forumTableView.dataSource = self
        self.forumSearchBar.delegate = self
        filteredData = threads
        
        self.forumTableView.estimatedRowHeight = 497.0
        self.forumTableView.rowHeight = UITableView.automaticDimension
        self.forumTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.forumTableView.register(UINib(nibName: "ForumTableViewCell", bundle: nil), forCellReuseIdentifier: "forumCellID")
        
        setBarTitle("Forum")
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        guard !searchText.isEmpty  else {
            filteredData = threads
            forumTableView.reloadData()
            return
        }

        filteredData = threads.filter({ title -> Bool in
            return title.forumTitle.lowercased().contains(searchText.lowercased())
        })
        
        forumTableView.reloadData()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCurrentUser()
        fetchForumData()
    }
    
    @IBAction func didTapNewNote() {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "NewForum") as? AddNewForumViewController else {
            return
        }
        
        vc.completion = {
            newEntry in
            self.navigationController?.popToRootViewController(animated: true)
            forumRepo.createForum(entry: newEntry)
                    
            self.forumTableView.isHidden = false
        }
        
        vc.currEntry = nil
        vc.isEditingEntry = false
        
        vc.title = "Buat Forum"
        
        setBackBarItem()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isSearching == true  {
            return self.filteredData.count
        }else {
            return self.threads.count
        }
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
        
        let index = (indexPath as NSIndexPath).section
        let forumSection = isSearching ? filteredData[index] : threads[index]
        
        let cell = forumTableView.dequeueReusableCell(withIdentifier: "forumCellID", for: indexPath) as! ForumTableViewCell
    
        cell.threadID = forumSection.id
        cell.categoryForum.setTitle(forumSection.category, for: .normal)
        cell.categoryForum.setCategoryColor(forumSection.category)
        cell.dateForum.text = forumSection.date.toString("MMM d, yyyy")
        cell.titleForum.text = forumSection.forumTitle
        cell.descForum.text = forumSection.forumDesc
        cell.commentForum.threadID = forumSection.id
        cell.commentForum.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
        cell.commentForum.setTitle(String(forumSection.count), for: .normal)
        cell.commentForum.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        if(forumSection.forumThumbnail == EMPTY_IMAGE){
            cell.imgForum.isHidden = true
        }
        
        let forumImgUrl = URL(string: forumSection.forumThumbnail)!
        cell.imgForum.load(url: forumImgUrl)
        
        let authorImgUrl = URL(string: forumSection.authorAvatar)!
        cell.authorImg.load(url: authorImgUrl)
        
        cell.authorName.text = forumSection.authorName
        cell.authorUsername.text = "@" + forumSection.authorUsername
        
        // set saved button state
        if(currUser!.saves.contains(cell.threadID!)){
            cell.isSaved = true
        }
        else{
            cell.isSaved = false
        }
        
        cell.setSavedStateImage()
        
        return cell
    }
    
    @objc func segueToNextView(_ sender: CommentButton){
        let sb = UIStoryboard(name: "CommentStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CommentController") as! CommentController
        vc.forumId = sender.threadID!
        present(vc, animated: true)
    }
    
    func fetchCurrentUser(){
        profileRepo.fetchCurrentUser{ currUser in
            self.currUser = currUser
        }
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
            
            threads = newEntries
            
            forumTableView.dataSource = self
            forumTableView.delegate = self
            forumTableView.reloadData()
        }
        
    }
    
}

