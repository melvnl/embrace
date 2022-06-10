//
//  FirestoreHelper.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 10/06/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase

let fs = FirestoreHelper()

class FirestoreHelper {
    
    let settings = FirestoreSettings()
    let db = Firestore.firestore()
    var rootJournal : CollectionReference
    
    init(){
        Firestore.firestore().settings = settings
        rootJournal = db.collection("journals")
    }
    
    func fetchJournals(entries: @escaping (_ entries: [Entry]) -> Void){
        
        rootJournal.whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid)
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
                        var entryList : [Entry] = []
                        for document in querySnapshot!.documents {
                            let currEntry = Entry(
                                title: document.get("title")! as! String,
                                desc: document.get("desc")! as! String,
                                mood: document.get("mood") as! Int,
                                date: document.get("date") as! Double,
                                user_id: Auth.auth().currentUser!.uid
                            )
                            entryList.append(currEntry)
                        }
                        entries(entryList)
                    }
                }
            }
    }
}
