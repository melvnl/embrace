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
            fs.rootThreadKehamilan.addDocument(data: [
                "title": entry.title,
                "desc": entry.desc,
                "category": entry.category,
                "date": FieldValue.serverTimestamp(),
                "user_id": entry.user_id,
                "image": entry.image
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 2){
            fs.rootThreadPerawatanBayi.addDocument(data: [
                "title": entry.title,
                "desc": entry.desc,
                "category": entry.category,
                "date": FieldValue.serverTimestamp(),
                "user_id": entry.user_id,
                "image": entry.image
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 3){
            fs.rootThreadKesehatanMental.addDocument(data: [
                "title": entry.title,
                "desc": entry.desc,
                "category": entry.category,
                "date": FieldValue.serverTimestamp(),
                "user_id": entry.user_id,
                "image": entry.image
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 4){
            fs.rootThreadPascaMelahirkan.addDocument(data: [
                "title": entry.title,
                "desc": entry.desc,
                "category": entry.category,
                "date": FieldValue.serverTimestamp(),
                "user_id": entry.user_id,
                "image": entry.image
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 5){
            fs.rootThreadPengasuhanAnak.addDocument(data: [
                "title": entry.title,
                "desc": entry.desc,
                "category": entry.category,
                "date": FieldValue.serverTimestamp(),
                "user_id": entry.user_id,
                "image": entry.image
            ]){
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }else if(entry.category == 6){
            fs.rootThreadLainnya.addDocument(data: [
                "title": entry.title,
                "desc": entry.desc,
                "category": entry.category,
                "date": FieldValue.serverTimestamp(),
                "user_id": entry.user_id,
                "image": entry.image
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
