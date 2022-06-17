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
    var rootThreadKehamilan : CollectionReference
    var rootThreadPerawatanBayi : CollectionReference
    var rootThreadKesehatanMental : CollectionReference
    var rootThreadPascaMelahirkan : CollectionReference
    var rootThreadPengasuhanAnak : CollectionReference
    var rootThreadLainnya : CollectionReference
    var rootUsers: CollectionReference
    var rootComments: CollectionReference
    
    init(){
        Firestore.firestore().settings = settings
        rootJournal = db.collection("journals")
        
        rootThreadKehamilan = db.collection("forum").document("kehamilan").collection("list-kehamilan")
        rootThreadPerawatanBayi = db.collection("forum").document("perawatan-bayi").collection("list-perawatan-bayi")
        rootThreadKesehatanMental = db.collection("forum").document("kesehatan-mental").collection("list-kesehatan-mental")
        rootThreadPascaMelahirkan = db.collection("forum").document("pasca-melahirkan").collection("list-pasca-melahirkan")
        rootThreadPengasuhanAnak = db.collection("forum").document("pengasuhan-anak").collection("list-pengasuhan-anak")
        rootThreadLainnya = db.collection("forum").document("lainnya").collection("list-lainnya")
        
        rootUsers = db.collection("users")
        rootComments = db.collection("comments")
    }

}
