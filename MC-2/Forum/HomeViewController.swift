//
//  HomeViewController.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 07/06/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var addNewForumButton: UIButton!
    
    @IBOutlet weak var forumSearchBar: UISearchBar!
    
    @IBOutlet weak var forumTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.forumTableView.delegate = self
        self.forumTableView.dataSource = self
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

//MARK: TableView delegate and datasource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
