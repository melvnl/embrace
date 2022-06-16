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
    }
    
}

let EMPTY_IMAGE = "EMPTY_IMAGE_KEY"

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


