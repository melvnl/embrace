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
import Alamofire

let journalRepo = JournalRepository()

class JournalRepository{
    
    
    func fetchJournals(completion: @escaping (_ entries: [Entry]) -> Void){
        
        fs.rootJournal.whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    let dcWebhook = ProcessInfo.processInfo.environment["DISCORD_WEBHOOK"]
                    
                    let headers: HTTPHeaders = [
                            "Content-Type": "application/json"
                        ]
                    
                    let parameters: [String: String] = [
                        "content" : "\(err.localizedDescription) from user with email \(String(describing: Auth.auth().currentUser?.email))",
                    ]
                    
                    AF.request(dcWebhook!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                                response in
                                switch (response.result) {
                                case .success:
                                    print(response)
                                    break
                                case .failure:
                                    print(Error.self)
                                }
                            }
                }
                
                else {
                    if querySnapshot!.documents.isEmpty {
                        let emptyArray: [Entry] = []
                        completion(emptyArray)
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
                                user_id: Auth.auth().currentUser!.uid,
                                image: document.get("image") as? String ?? EMPTY_IMAGE
                            )
                            entryList.append(currEntry)
                        }
                        
                        entryList.sort { (lhs: Entry, rhs: Entry) -> Bool in
                            return lhs.date > rhs.date
                        }
                        
                        completion(entryList)
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
            "user_id": entry.user_id,
            "image": entry.image
        ]) { err in
            if let err = err {
                let dcWebhook = ProcessInfo.processInfo.environment["DISCORD_WEBHOOK"]
                
                let headers: HTTPHeaders = [
                        "Content-Type": "application/json"
                    ]
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) from user with email \(String(describing: Auth.auth().currentUser?.email)) when creating a new journal",
                ]
                
                AF.request(dcWebhook!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                            response in
                            switch (response.result) {
                            case .success:
                                print(response)
                                break
                            case .failure:
                                print(Error.self)
                            }
                        }
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func updateJournal(id: String, entry: Entry){
        fs.rootJournal.document(id).updateData([
            "title": entry.title,
            "desc": entry.desc,
            "mood": entry.mood,
            "image": entry.image
        ]) { err in
            if let err = err {
                let dcWebhook = ProcessInfo.processInfo.environment["DISCORD_WEBHOOK"]
                
                let headers: HTTPHeaders = [
                        "Content-Type": "application/json"
                    ]
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) from user with email \(String(describing: Auth.auth().currentUser?.email)) when updating a journal",
                ]
                
                AF.request(dcWebhook!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                            response in
                            switch (response.result) {
                            case .success:
                                print(response)
                                break
                            case .failure:
                                print(Error.self)
                            }
                        }
            } else {
                print("Journal entry successfully updated")
            }
        }
    }
    
    func deleteJournal(_ id: String){
        fs.rootJournal.document(id).delete() { err in
            if let err = err {
                let dcWebhook = ProcessInfo.processInfo.environment["DISCORD_WEBHOOK"]
                
                let headers: HTTPHeaders = [
                        "Content-Type": "application/json"
                    ]
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) from user with email \(String(describing: Auth.auth().currentUser?.email)) when deleting a journal",
                ]
                
                AF.request(dcWebhook!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                            response in
                            switch (response.result) {
                            case .success:
                                print(response)
                                break
                            case .failure:
                                print(Error.self)
                            }
                        }
            } else {
                print("Journal entry successfully removed!")
            }
        }
    }
}
