//
//  NoteViewController.swift
//  Notes
//
//  Created by Afraz Siddiqui on 3/16/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var titleLabel: UITextView!
    @IBOutlet var noteLabel: UITextView!

    public var noteTitle: String = ""
    public var note: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = noteTitle
        noteLabel.text = note
        
        titleLabel.isEditable = false
        noteLabel.isEditable = false
        
        setBarButtons()
    }
    
    @objc func editNote(){
        titleLabel.isEditable = true
        noteLabel.isEditable = true
        titleLabel.becomeFirstResponder()
        
        let SaveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        self.navigationItem.rightBarButtonItems = [SaveBarButtonItem]
    }
    
    @objc func saveNote(){
        titleLabel.isEditable = false
        noteLabel.isEditable = false
        setBarButtons()
        
        //save data below
    }
    
    @objc func deleteNote(){
        // delete here
    }
    
    private func setBarButtons(){
        let EditBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editNote))
        let DeleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteNote))
        
        self.navigationItem.rightBarButtonItems  = [DeleteBarButtonItem, EditBarButtonItem]
    }


}
