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

        // Do any additional setup after loading the view.
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
        
        vc.title = "Buat jurnal"
        
        setBackBarItem()
        navigationController?.pushViewController(vc, animated: true)
    }
    


}
