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
        
        entryImage.alpha = 0
        
        loadImage()
        
        // Convert date to string
        entryDate.text = currEntry!.date.toString("MMM d, hh.mm")
        
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
            self.goToEdit()
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
    
    func goToEdit(){
        guard let vc = storyboard?.instantiateViewController(identifier: "EditJournal") as? EntryViewController else {
            return
        }
        
        vc.updateCompletion = { [self] newEntry in
            // Refresh entry data except date
            currEntry = newEntry
            entryTitle.text = currEntry?.title
            entryDesc.text = currEntry?.desc
            entryMood.text = getEntryMoodText(currEntry!)
            
            if(currEntry!.image != EMPTY_IMAGE){
                entryMoodIcon.image = getEntryMoodImage(currEntry!)
                loadImage()
            }
            else{
                // Hide previously loaded image
                entryImage.alpha = 0
            }
            
            // Update in firestore
            journalRepo.updateJournal(id: currEntry!.id, entry: currEntry!)
            navigationController?.popViewController(animated: true)
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Edit jurnal"
        vc.currEntry = self.currEntry
        vc.isEditingEntry = true
        
        setBackBarItem()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadImage(){
        if(currEntry!.image != EMPTY_IMAGE){
            // load image
            let url = URL(string: currEntry!.image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.entryImage.image = UIImage(data: data!)
                    UIView.animate(withDuration: 0.2) {
                        self.entryImage.alpha = 1.0
                    }
                }
            }
        }
    }
}

