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
import FirebaseFirestoreSwift
import Alamofire

let forumRepo = ForumRepository()

class ForumRepository {
    
    func createForum(entry: EntryForum){
        fs.rootForum.addDocument(data: [
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
                let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                
                let headers: HTTPHeaders = [
                        "Content-Type": "application/json"
                    ]
                
                let parameters: [String: String] = [
                    "content" : err.localizedDescription,
                ]
                
                AF.request(dcWebhook, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
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
    
    func fetchAllThreads(completion: @escaping (_ threads: [EntryForum]) -> Void){
        fs.rootForum.getDocuments() { (querySnapshot, err) in
                
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
            fs.rootForum.whereField("authorUsername", isEqualTo: username)
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
    
    func fetchSavedThreads(_ saves: [String], completion: @escaping (_ threads: [EntryForum]) -> Void){
    
        var savedThreads : [EntryForum] = []
//        
//        if(saves.count == 0 || saves.isEmpty){
//            completion(savedThreads)
//        }
        
        fs.rootForum.getDocuments() { (querySnapshot, err) in
                
            if let err = err {
                print("Error getting user threads: \(err)")
            }
            
            else {
                if querySnapshot!.documents.isEmpty {
                    let emptyArray: [EntryForum] = []
                    completion(emptyArray)
                }
                else{
                    for document in querySnapshot!.documents {
                        let currId = document.documentID
                        if (saves.contains(currId)){
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
                            savedThreads.append(currThread)
                        }
                    }
                    
                    savedThreads.sort { (lhs: EntryForum, rhs: EntryForum) -> Bool in
                        return lhs.date > rhs.date
                    }
                    
                    completion(savedThreads)
                }
            }
        }
    }
    
    func saveThread(_ id: String){
        fs.rootUsers.document(Auth.auth().currentUser!.uid).updateData(([
            "saves": FieldValue.arrayUnion([id])
        ])) { err in
            if let err = err{
                print("Error saving thread: \(err)")
            }
            else{
                print("Thread successfully saved")
            }
        }
    }
    
    func deleteSavedThread(_ id: String){
        fs.rootUsers.document(Auth.auth().currentUser!.uid).updateData(([
            "saves": FieldValue.arrayRemove([id])
        ])) { err in
            if let err = err{
                print("Error deleting saved thread: \(err)")
            }
            else{
                print("Saved thread successfully deleted")
            }
        }
    }
}
