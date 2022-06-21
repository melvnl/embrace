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

let profileRepo = ProfileRepository()

class ProfileRepository{
    func fetchCurrentUser(completion: @escaping (_ currUser: ProfileEntry) -> Void){
        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                let currUser = ProfileEntry(
                    username: doc.get("username") as? String ?? "",
                    name: doc.get("name") as? String ?? "",
                    description: doc.get("description") as? String ?? "",
                    avatar: doc.get("avatar") as! String
                )
                completion(currUser)
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func updateProfile(uid: String, entry: ProfileEntry) {
        Firestore.firestore().collection("users").document(uid).updateData([
            "name": entry.name,
            "description": entry.description,
            "avatar": entry.avatar
        ]) { err in
            if let err = err {
                print("Error updating your profile: \(err) ")
            }
            else {
                print("Your profile has been updated successfully!")
            }
        }
    }
}
