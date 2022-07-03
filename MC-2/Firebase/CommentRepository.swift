//
//  CommentRepository.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 29/06/22.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

let commentRepo = CommentRepository()

class CommentRepository{
    
    func fetchComments(_ id: String, completion: @escaping (_ comments: [Comment]) -> Void){
        
        var comments : [Comment] = []
        
        fs.rootComments.whereField("forumId", isEqualTo: id).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting comments: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    let ts = document.get("date") as! Timestamp
                    let commentEntry = Comment(
                        forumId: document.get("forumId")! as! String,
                        avatar: document.get("authorAvatar") as? String ?? "",
                        username: document.get("authorUsername") as? String ?? "",
                        name: document.get("authorName") as? String ?? "",
                        value: document.get("value")! as! String,
                        date: ts.dateValue()
                    )
                    comments.append(commentEntry)
                }
                
                comments.sort { (lhs: Comment, rhs: Comment) -> Bool in
                    return lhs.date > rhs.date
                }
                
                completion(comments)
            }
        } 
    }
    
    func createComment(_ comment: Comment, completion: @escaping (_ success: Bool) -> Void){
        fs.db.collection("comments").addDocument(data: [
            "forumId": comment.forumId,
            "value": comment.value,
            "authorName": comment.name,
            "authorUsername": comment.username,
            "authorAvatar": comment.avatar,
            "date": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error posting comment: \(err) ")
                completion(false)
            }
            else {
                print("Comment has been posted successfully!")
                completion(true)
            }
        }
    }
}
