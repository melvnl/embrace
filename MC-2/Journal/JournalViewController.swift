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

@available(iOS 15.0, *)
class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchController:UISearchController!
    var searchResults:[Entry] = []
    var entries: [Entry] = []
    var db: Firestore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Firestore setup
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        table.delegate = self
        table.dataSource = self
    
        fetchData() {() in
            print("reloading table")
            self.table.reloadData()
        }
        
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
    
    func fetchData(completion: @escaping() -> Void){
        db.collection("journals").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting journal entries: \(err)")
                }
                else {
                    if querySnapshot!.documents.isEmpty {
                        print("No documents")
                        print(Auth.auth().currentUser!.uid)
                    }
                    else{
                        var entries : [Entry] = []
                        for document in querySnapshot!.documents {
                            let currEntry = Entry(
                                title: document.get("title")! as! String,
                                desc: document.get("desc")! as! String,
                                mood: document.get("mood") as! Int,
                                date: document.get("date") as! Double,
                                user_id: Auth.auth().currentUser!.uid
                            )
                            entries.append(currEntry)
                        }
                        
                        DispatchQueue.main.async {
                            self.entries = entries
                            self.table.reloadData()
                            print(self.entries)
                            completion()
                        }
                    }
                }
            }
    }

    @IBAction func didTapNewNote() {
        searchController.isActive = false
        
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }
        
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            self.navigationController?.popToRootViewController(animated: true)
            
            self.db.collection("journals").addDocument(data: [
                "title": noteTitle,
                "desc": note,
                "mood": 1,
                "date": Date().timeIntervalSinceReferenceDate,
                "user_id": Auth.auth().currentUser!.uid
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
            
            self.label.isHidden = true
            self.table.isHidden = false

            self.fetchData() {() in
                print("reloading table")
                self.table.reloadData()
            }
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
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let entry = entries[indexPath.row]

        // Show note controller
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {
            return
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = entry.title
        vc.noteTitle = entry.title
        vc.note = entry.desc
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
        if let searchText = searchController.searchBar.text {
                filterContentForSearchText(searchText)
                table.reloadData()
        }
    }

}


