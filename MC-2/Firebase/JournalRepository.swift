//
//  JournalRepository.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 10/06/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

let journalRepo = JournalRepository()

class JournalRepository{
    
    
    func fetchJournals(entries: @escaping (_ entries: [Entry]) -> Void){
        
        fs.rootJournal.whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting journal entries: \(err)")
                }
                
                else {
                    if querySnapshot!.documents.isEmpty {
                        let emptyArray: [Entry] = []
                        entries(emptyArray)
                    }
                    else{
                        var entryList : [Entry] = []
                        for document in querySnapshot!.documents {
                            let ts = document.get("date") as! Timestamp
                            let currEntry = Entry(
                                id: document.documentID,
                                title: document.get("title")! as! String,
                                desc: document.get("desc")! as! String,
                                mood: document.get("mood") as! Int,
                                date: ts.dateValue(),
                                user_id: Auth.auth().currentUser!.uid
                            )
                            entryList.append(currEntry)
                        }
                        entries(entryList)
                    }
                }
            }
    }
    
    func createJournal(entry: Entry){
        fs.rootJournal.addDocument(data: [
            "title": entry.title,
            "desc": entry.desc,
            "mood": entry.mood,
            "date": FieldValue.serverTimestamp(),
            "user_id": entry.user_id
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateJournal(id: String, entry: Entry){
        fs.rootJournal.document(id).updateData([
            "title": entry.title,
            "desc": entry.desc
        ]) { err in
            if let err = err {
                print("Error updating journal entry: \(err)")
            } else {
                print("Journal entry successfully updated")
            }
        }
    }
    
    func deleteJournal(_ id: String){
        fs.rootJournal.document(id).delete() { err in
            if let err = err {
                print("Error removing journal entry: \(err)")
            } else {
                print("Journal entry successfully removed!")
            }
        }
    }
}
