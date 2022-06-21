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
    var rootThread : CollectionReference
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
        rootThread = db.collection("threads")
        
        rootThreadKehamilan = db.collection("forum").document("9nc6jyqsNkEiYWALSaFB").collection("kehamilan")
        rootThreadPerawatanBayi = db.collection("forum").document("MhfVjWwVwh2A71UbwmGm").collection("perawatanBayi")
        rootThreadKesehatanMental = db.collection("forum").document("dVUrYrYtKv84rfsJKK4X").collection("kesehatanMental")
        rootThreadPascaMelahirkan = db.collection("forum").document("xiVO0oAAe4DeIAw1HVnr").collection("pascaMelahirkan")
        rootThreadPengasuhanAnak = db.collection("forum").document("dQIvuouAiXBvNw6r1xli").collection("pengasuhanAnak")
        rootThreadLainnya = db.collection("forum").document("ZipnEyNDulyNeXvlzXCw").collection("lainnya")
        
        rootUsers = db.collection("users")
        rootComments = db.collection("comments")
    }

}
