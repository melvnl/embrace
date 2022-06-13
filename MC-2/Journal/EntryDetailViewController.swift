//
//  NoteViewController.swift
//  Notes
//
//  Created by Afraz Siddiqui on 3/16/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entryDesc: UITextView!
    @IBOutlet weak var entryMood: UILabel!
    @IBOutlet weak var entryMoodIcon: UIImageView!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var entryImage: UIImageView!
    
    public var currEntry : Entry? = nil
    
    public var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryTitle.text = currEntry?.title
        entryDesc.text = currEntry?.desc
        
        entryMood.text = getEntryMoodText(currEntry!)
        entryMoodIcon.image = getEntryMoodImage(currEntry!)
        
        // Convert date to string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh.mm"
        entryDate.text = dateFormatter.string(from: currEntry!.date)
        
        title = "Lihat jurnal"
    
        // Add edit bar item
        let EditBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(editEntry))
        EditBarButtonItem.image = UIImage(systemName: "pencil")
        EditBarButtonItem.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = EditBarButtonItem
    }
    
    @objc func editEntry(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
        alert.addAction(UIAlertAction(title: "Ubah", style: .default , handler:{ (UIAlertAction)in
            print("User click hari button")
            }))
        
        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler:{ (UIAlertAction)in
            self.showDeleteAlert()
            }))
        
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler:{ (UIAlertAction)in
            print("User click cancel button")
            }))

            
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func showDeleteAlert(){
        let alert = UIAlertController(title: "Hapus Jurnal?", message: "Apakah Anda yakin ingin menghapus jurnal ini?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Batal", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Hapus", style: UIAlertAction.Style.destructive, handler: { action in
            journalRepo.deleteJournal(self.currEntry!.id)
            self.navigationController?.popViewController(animated: true)
        }))
       
        self.present(alert, animated: true, completion: nil)
    }
}

