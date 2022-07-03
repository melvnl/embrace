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
                    
                    let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String
                    
                    let headers: HTTPHeaders = [
                            "Content-Type": "application/json"
                        ]
                    
                    let parameters: [String: String] = [
                        "content" : error.localizedDescription,
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
                print("Error updating your profile: \(err) ")
            }
            else {
                print("Your profile has been updated successfully!")
            }
        }
    }
}
