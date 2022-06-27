//
//  FirestoreHelper.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 10/06/22.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase
import FirebaseStorage

let fs = FirestoreHelper()

class FirestoreHelper {
    
    let settings = FirestoreSettings()
    let db = Firestore.firestore()
    var rootJournal : CollectionReference
    var rootForum : CollectionReference
    var rootSaves : CollectionReference
    var rootUsers: CollectionReference
    var rootComments: CollectionReference
    
    init(){
        Firestore.firestore().settings = settings
        rootJournal = db.collection("journals")
        rootForum = db.collection("forums")
        rootSaves = db.collection("saves")
        rootUsers = db.collection("users")
        rootComments = db.collection("comments")
    }

}
