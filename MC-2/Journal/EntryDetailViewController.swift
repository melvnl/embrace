//
//  NoteViewController.swift
//  Notes
//
//  Created by Afraz Siddiqui on 3/16/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    
    @IBOutlet weak var entryTitle: UITextView!
    @IBOutlet weak var entryDesc: UITextView!
    
    public var currEntry : Entry? = nil
    
    public var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryTitle.text = currEntry?.title
        entryDesc.text = currEntry?.desc
        title = currEntry?.title
        
        entryTitle.isEditable = false
        entryDesc.isEditable = false
        
        setBarButtons()
    }
    
    @objc func editEntry(){
        entryTitle.isEditable = true
        entryDesc.isEditable = true
        entryTitle.becomeFirstResponder()
        
        let SaveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveEntry))
        self.navigationItem.rightBarButtonItems = [SaveBarButtonItem]
    }
    
    @objc func saveEntry(){
        entryTitle.isEditable = false
        entryDesc.isEditable = false
        setBarButtons()
        
        //update document
        let newEntry = Entry(
            id: currEntry!.id,
            title: entryTitle.text,
            desc: entryDesc.text,
            mood: currEntry!.mood,
            date: currEntry!.date,
            user_id: currEntry!.user_id
        )
        
        title = newEntry.title
        
        journalRepo.updateJournal(id: currEntry!.id, entry: newEntry)
    }
    
    @objc func deleteEntry(){
        // delete document
        journalRepo.deleteJournal(currEntry!.id)
        //navigate to journals
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func setBarButtons(){
        let EditBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editEntry))
        let DeleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteEntry))
        
        self.navigationItem.rightBarButtonItems  = [DeleteBarButtonItem, EditBarButtonItem]
    }
}

