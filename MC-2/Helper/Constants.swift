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
        static let kehamilan = "kehamilan"
        static let perawatanBayi = "Perawatan Bayi"
        static let pengasuhanAnak = "Pengasuhan Anak"
        static let kesehatanMental = "Kesehatan Mental"
        static let pascaMelahirkan = "Pasca Melahirkan"
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

enum Category: String {
    case KEHAMILAN = "Kehamilan"
    case PERAWATAN_BAYI = "Perawatan Bayi"
    case KESEHATAN_MENTAL = "Kesehatan Mental"
    case PASCA_MELAHIRKAN = "Pasca Melahirkan"
    case PENGASUHAN_ANAK = "Pengasuhan Anak"
    case LAINNYA = "Lainnya"
}

func getIndexFromCategory(_ category: Category) -> Int{
    switch(category){
    case .KEHAMILAN: return 1
    case .PERAWATAN_BAYI: return 2
    case .KESEHATAN_MENTAL: return 3
    case .PASCA_MELAHIRKAN: return 4
    case .PENGASUHAN_ANAK: return 5
    case .LAINNYA: return 6
    }
}

let EMPTY_IMAGE = "EMPTY_IMAGE_KEY"
