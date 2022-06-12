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
class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    var entries: [Entry] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        table.isHidden = false
        table.delegate = self
        table.dataSource = self

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
        
        guard let vc = storyboard?.instantiateViewController(identifier: "NewJournal") as? EntryViewController else {
            return
        }
        vc.completion = { newEntry in
            self.navigationController?.popToRootViewController(animated: true)
            journalRepo.createJournal(entry: newEntry)
            
            self.label.isHidden = true
            self.table.isHidden = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapFilter(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Saring berdasarkan", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Hari", style: .default , handler:{ (UIAlertAction)in
                print("User click hari button")
            }))

            alert.addAction(UIAlertAction(title: "Minggu", style: .default , handler:{ (UIAlertAction)in
                print("User click minggu button")
            }))
        
            alert.addAction(UIAlertAction(title: "Bulan", style: .default , handler:{ (UIAlertAction)in
                print("User click bulan button")
            }))
            
            alert.addAction(UIAlertAction(title: "Tahun", style: .default, handler:{ (UIAlertAction)in
                print("User click tahun button")
            }))
        
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                print("User click cancel button")
            }))

            
            //uncomment for iPad Support
            //alert.popoverPresentationController?.sourceView = self.view

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
    }
    
    func popUpModal(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FilterPopup")
            
        if let presentationController = viewController.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
                
        self.present(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! EntryCell
        
        let currEntry = entries[(indexPath as NSIndexPath).row]
        
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
        guard let vc = storyboard?.instantiateViewController(identifier: "ViewJournal") as? EntryDetailViewController else {
            return
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.currEntry = entries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}




