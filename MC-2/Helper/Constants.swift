//
//  Constants.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 07/06/22.
//

import Foundation

struct Constants {
    struct Storyboard {
        static let homeViewController = "HomeVC"
        static let loginViewController = "LoginVC"
        static let verificationViewController = "VerifVC"
        static let topicViewController = "TopicVC"
        static let topicDetailController = "TopicDetailVC"
    }
    
    struct ForumCollections {
        static let kehamilan = "9nc6jyqsNkEiYWALSaFB"
        static let perawatanBayi = "MhfVjWwVwh2A71UbwmGm"
        static let pengasuhanAnak = "dQIvuouAiXBvNw6r1xli"
        static let kesehatanMental = "dVUrYrYtKv84rfsJKK4X"
        static let pascaMelahirkan = "xiVO0oAAe4DeIAw1HVnr"
    }
    
}

enum Mood: Int {
    case veryHappy = 1
    case happy = 2
    case neutral = 3
    case sad = 4
    case verySad = 5
}

enum JournalFilterType: String{
    case week = "WEEK_FILTER_KEY"
    case month = "MONTH_FILTER_KEY"
    case year = "YEAR_FILTER_KEY"
}

let KEHAMILAN = 1
let PERAWATAN_BAYI = 2
let KESEHATAN_MENTAL = 3
let PASCA_MELAHIRKAN = 4
let PENGASUHAN_ANAK = 5
let LAINNYA = 6
let EMPTY_IMAGE = "EMPTY_IMAGE_KEY"
