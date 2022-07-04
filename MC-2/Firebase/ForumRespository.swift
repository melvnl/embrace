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

let headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]

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
            "authorAvatar" : entry.authorAvatar,
            "count": 0
        ]){
            err in
            if let err = err {
                
                let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) when creating new forum - \(Auth.auth().currentUser?.email)",
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
                    let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                    
                    let parameters: [String: String] = [
                        "content" : "\(err.localizedDescription) when fetching all forum - \(Auth.auth().currentUser?.email)",
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
                                forumThumbnail: document.get("forumThumbnail") as! String,
                                count: document.get("count") as! Int
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
    
    func fetchCategoryThreads(_ id: String, completion: @escaping (_ threads: [EntryForum]) -> Void){
        fs.rootForum.whereField("category", isEqualTo: id).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                    
                    let parameters: [String: String] = [
                        "content" : "\(err.localizedDescription) when fetching category forum - \(Auth.auth().currentUser?.email)",
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
                                forumThumbnail: document.get("forumThumbnail") as! String,
                                count: document.get("count") as! Int
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
                        let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                        
                        let parameters: [String: String] = [
                            "content" : "\(err.localizedDescription) when fetch forum from \(username)",
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
                                    forumThumbnail: document.get("forumThumbnail") as! String,
                                    count: document.get("count") as! Int
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
                let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) when fetching saved threads from - \(Auth.auth().currentUser?.email)",
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
                                forumThumbnail: document.get("forumThumbnail") as! String,
                                count: document.get("count") as! Int
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
                let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) when save a thread/forum - \(Auth.auth().currentUser?.email)",
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
                let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) when deleting a saved forum from user with id - \(id) \(Auth.auth().currentUser?.email)",
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
            }
            else{
                print("Saved thread successfully deleted")
            }
        }
    }
    
    func addCommentCounter(_ id: String){
        fs.rootForum.document(id).updateData([
            "count": FieldValue.increment(Int64(1))
        ]) { err in
            if let err = err{
                let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) when updating comment counter of forum with id - \(id)",
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
            }
            else{
                print("Updated comment counter successfully")
            }
        }
    }
}
