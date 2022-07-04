//
//  ProfileRepository.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 16/06/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit
import Alamofire

let profileRepo = ProfileRepository()

class ProfileRepository{
    func fetchCurrentUser(completion: @escaping (_ currUser: ProfileEntry) -> Void){
        fs.rootUsers.document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                let currUser = ProfileEntry(
                    username: doc.get("username") as? String ?? "",
                    name: doc.get("nama") as? String ?? "",
                    description: doc.get("description") as? String ?? "",
                    avatar: doc.get("avatar") as? String ?? DEFAULT_AVATAR,
                    saves: doc.get("saves") as? [String] ?? []
                )
                completion(currUser)
            } else {
                if let error = error {
                    
                    let dcWebhook = ProcessInfo.processInfo.environment["DISCORD_WEBHOOK"]
                    
                    let headers: HTTPHeaders = [
                            "Content-Type": "application/json"
                        ]
                    
                    let parameters: [String: String] = [
                        "content" : "\(error.localizedDescription) when getting account information from user with uid: \(Auth.auth().currentUser!.uid)",
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
            }
        }
    }
    
    func updateProfile(uid: String, entry: ProfileEntry) {
        
        fs.rootUsers.document(uid).updateData([
            "nama": entry.name,
            "description": entry.description,
            "avatar": entry.avatar
        ]) { err in
            if let err = err {
                let dcWebhook = ProcessInfo.processInfo.environment["DISCORD_WEBHOOK"]
                
                let headers: HTTPHeaders = [
                        "Content-Type": "application/json"
                    ]
                
                let parameters: [String: String] = [
                    "content" : "\(err.localizedDescription) when updating user profile : \(Auth.auth().currentUser!.uid)",
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
                self.updateForumProfile(entry)
                self.updateCommentProfile(entry)
                print("Your profile has been updated successfully!")
            }
        }
        
    }
    
    func updateCommentProfile(_ entry: ProfileEntry){
        var username = entry.username
        username.remove(at: username.startIndex)
        fs.rootComments
            .whereField("authorUsername", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    let dcWebhook = ProcessInfo.processInfo.environment["DISCORD_WEBHOOK"]
                    
                    let headers: HTTPHeaders = [
                            "Content-Type": "application/json"
                        ]
                    
                    let parameters: [String: String] = [
                        "content" : "\(err.localizedDescription) when updating user profile : \(Auth.auth().currentUser!.uid)",
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
                    let batch = fs.db.batch()
                    for document in querySnapshot!.documents {
                        
                        batch.updateData(
                            [
                                "authorAvatar": entry.avatar,
                                "authorName": entry.name
                            ], forDocument: document.reference)
                        print("Updating document uid: \(document.documentID)")
                    }
                    batch.commit()
                }
            }
    }
    
    func updateForumProfile(_ entry: ProfileEntry){
        var username = entry.username
        username.remove(at: username.startIndex)
        fs.rootForum
            .whereField("authorUsername", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    let dcWebhook = ProcessInfo.processInfo.environment["DISCORD_WEBHOOK"]
                    
                    let headers: HTTPHeaders = [
                            "Content-Type": "application/json"
                        ]
                    
                    let parameters: [String: String] = [
                        "content" : "\(err.localizedDescription) when updating user profile : \(Auth.auth().currentUser!.uid)",
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
                    let batch = fs.db.batch()
                    for document in querySnapshot!.documents {
                        
                        batch.updateData(
                            [
                                "authorAvatar": entry.avatar,
                                "authorName": entry.name
                            ], forDocument: document.reference)
                        print("Updating document uid: \(document.documentID)")
                    }
                    batch.commit()
                }
            }
    }
    
}
