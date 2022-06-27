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
        if(entry.category == 1) {
            fs.rootThread.addDocument(data: [
                "forumTitle": entry.forumTitle,
                "forumDesc": entry.forumDesc,
                "category": "kehamilan",
                "date": FieldValue.serverTimestamp(),
                "authorName": entry.authorName,
                "authorUsername" : entry.authorUsername,
                "authorThumbnail": entry.authorThumbnail,
                "authorAvatar" : entry.authorAvatar
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 2){
            fs.rootThread.addDocument(data: [
                "forumTitle": entry.forumTitle,
                "forumDesc": entry.forumDesc,
                "category": "kehamilan",
                "date": FieldValue.serverTimestamp(),
                "authorName": entry.authorName,
                "authorUsername" : entry.authorUsername,
                "authorThumbnail": entry.authorThumbnail,
                "authorAvatar" : entry.authorAvatar
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 3){
            fs.rootThread.addDocument(data: [
                "forumTitle": entry.forumTitle,
                "forumDesc": entry.forumDesc,
                "category": "kehamilan",
                "date": FieldValue.serverTimestamp(),
                "authorName": entry.authorName,
                "authorUsername" : entry.authorUsername,
                "authorThumbnail": entry.authorThumbnail,
                "authorAvatar" : entry.authorAvatar
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 4){
            fs.rootThread.addDocument(data: [
                "forumTitle": entry.forumTitle,
                "forumDesc": entry.forumDesc,
                "category": "kehamilan",
                "date": FieldValue.serverTimestamp(),
                "authorName": entry.authorName,
                "authorUsername" : entry.authorUsername,
                "authorThumbnail": entry.authorThumbnail,
                "authorAvatar" : entry.authorAvatar
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 5){
            fs.rootThread.addDocument(data: [
                "forumTitle": entry.forumTitle,
                "forumDesc": entry.forumDesc,
                "category": "kehamilan",
                "date": FieldValue.serverTimestamp(),
                "authorName": entry.authorName,
                "authorUsername" : entry.authorUsername,
                "authorThumbnail": entry.authorThumbnail,
                "authorAvatar" : entry.authorAvatar
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 6){
            fs.rootThread.addDocument(data: [
                "forumTitle": entry.forumTitle,
                "forumDesc": entry.forumDesc,
                "category": "kehamilan",
                "date": FieldValue.serverTimestamp(),
                "authorName": entry.authorName,
                "authorUsername" : entry.authorUsername,
                "authorThumbnail": entry.authorThumbnail,
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
        
        
    }
    
    
}
