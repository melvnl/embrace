//
//  ForumRespository.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 16/06/22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

let forumRepo = ForumRepository()

class ForumRepository {
    
    func createForum(entry: EntryForum){
        fs.rootThread.addDocument(data: [
            "forumTitle": entry.forumTitle,
            "forumDesc": entry.forumDesc,
            "category": entry.category,
            "date": FieldValue.serverTimestamp(),
            "authorName": entry.authorName,
            "authorUsername" : entry.authorUsername,
            "forumThumbnail": entry.forumThumbnail,
            "authorAvatar" : entry.authorAvatar
        ]){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func fetchAllThreads(completion: @escaping (_ threads: [EntryForum]) -> Void){
        fs.rootThread.getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting user threads: \(err)")
                }
                
                else {
                    if querySnapshot!.documents.isEmpty {
                        let emptyArray: [EntryForum] = []
                        completion(emptyArray)
                    }
                    else{
                        var entryList : [EntryForum] = []
                        for document in querySnapshot!.documents {
                            let ts = document.get("date") as! Timestamp
                            let currThread = EntryForum(
                                id: document.documentID,
                                forumTitle: document.get("forumTitle")! as! String,
                                forumDesc: document.get("forumDesc")! as! String,
                                category: document.get("category") as! String,
                                date: ts.dateValue(),
                                authorName: document.get("authorName") as! String,
                                authorUsername: document.get("authorUsername") as! String,
                                authorAvatar: document.get("authorAvatar") as! String,
                                forumThumbnail: document.get("forumThumbnail") as! String
                            )
                            entryList.append(currThread)
                        }
                        
                        entryList.sort { (lhs: EntryForum, rhs: EntryForum) -> Bool in
                            return lhs.date > rhs.date
                        }
                        
                        completion(entryList)
                    }
                }
            }
    }
    
    func fetchUserThreads(completion: @escaping (_ threads: [EntryForum]) -> Void){
        let group = DispatchGroup()
        var username = ""
        group.enter()
        // Fetch current user data
        DispatchQueue.main.async {
            profileRepo.fetchCurrentUser{ currUser in
                username = currUser.username
                group.leave()
            }
        }
        
        group.notify(queue: .main){
            fs.rootThread.whereField("authorUsername", isEqualTo: username)
                .getDocuments() { (querySnapshot, err) in
                    
                    if let err = err {
                        print("Error getting user threads: \(err)")
                    }
                    
                    else {
                        if querySnapshot!.documents.isEmpty {
                            let emptyArray: [EntryForum] = []
                            completion(emptyArray)
                        }
                        else{
                            var entryList : [EntryForum] = []
                            for document in querySnapshot!.documents {
                                let ts = document.get("date") as! Timestamp
                                let currThread = EntryForum(
                                    id: document.documentID,
                                    forumTitle: document.get("forumTitle")! as! String,
                                    forumDesc: document.get("forumDesc")! as! String,
                                    category: document.get("category") as! String,
                                    date: ts.dateValue(),
                                    authorName: document.get("authorName") as! String,
                                    authorUsername: document.get("authorUsername") as! String,
                                    authorAvatar: document.get("authorAvatar") as! String,
                                    forumThumbnail: document.get("forumThumbnail") as! String
                                )
                                entryList.append(currThread)
                            }
                            
                            entryList.sort { (lhs: EntryForum, rhs: EntryForum) -> Bool in
                                return lhs.date > rhs.date
                            }
                            
                            completion(entryList)
                        }
                    }
                }
        }
    }
    
    func saveThread(_ entry: EntryForum){
        
    }
    
    func deleteSavedThread(_ entry: EntryForum){
        
    }
    
    
}
