//
//  JournalViewController.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 09/06/22.
//

import Foundation
import UIKit

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase
import simd

@available(iOS 15.0, *)
class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchController:UISearchController!
    var searchResults:[Entry] = []
    var entries: [Entry] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        table.isHidden = false
        table.delegate = self
        table.dataSource = self
        
        // Add a Search Bar Programmtically
        searchController = UISearchController(searchResultsController: nil)
        table.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Title"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.orange

        title = "Journal"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fillTable()
    }
    
    func fillTable(){
        journalRepo.fetchJournals { (entries) -> Void in
            DispatchQueue.main.async {
                self.entries = entries
                self.table.dataSource = self
                self.table.delegate = self
                self.table.isHidden = false
                self.table.reloadData()
            }
        }
    }

    @IBAction func didTapNewNote() {
        searchController.isActive = false
        
        guard let vc = storyboard?.instantiateViewController(identifier: "NewJournal") as? EntryViewController else {
            return
        }
        
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            let newEntry = Entry(
                id: "",
                title: noteTitle,
                desc: note,
                mood: 1,
                date: Date().timeIntervalSinceReferenceDate,
                user_id: Auth.auth().currentUser!.uid
            )
            journalRepo.createJournal(entry: newEntry)
            
            self.label.isHidden = true
            self.table.isHidden = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func didTapFilter(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterPopup")
            
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
                
        self.present(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        }
        else {
            return entries.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryCell
        
        let currEntry = (self.searchController.isActive) ? self.searchResults[(indexPath as NSIndexPath).row] : entries[(indexPath as NSIndexPath).row]
        
        
        cell.title.text = currEntry.title
        cell.desc.text = currEntry.desc
        cell.date.text = String(currEntry.date)
        cell.setMoodImage(currEntry.mood)
        
        cell.alpha = 0
        UIView.animate(withDuration: 1, animations: { cell.alpha = 1 })
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Show note controller
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewJournal") as? NoteViewController else {
            return
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.currEntry = entries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String) {
            searchResults = entries.filter({ (entry:Entry) -> Bool in
                let titleMatch = entry.title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return titleMatch != nil
            }
        )
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
        if let searchText = searchController.searchBar.text {
                filterContentForSearchText(searchText)
                table.reloadData()
        }
    }
}




