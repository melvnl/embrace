//
//  Entry.swift
//  Notes
//
//  Created by Tb. Daffa Amadeo Zhafrana on 08/06/22.
//  Copyright © 2022 ASN GROUP LLC. All rights reserved.
//
import Foundation
import UIKit

struct Entry{
    var id = ""
    var title = ""
    var desc = ""
    var mood = 0
    var date = Date.now
    var user_id = ""
    var image = EMPTY_IMAGE
}

func getEntryMoodImage(_ entry: Entry) -> UIImage{
    switch (entry.mood){
    case Mood.veryHappy.rawValue:
        return UIImage(named: "VHappySelectedIcon")!
    case Mood.happy.rawValue:
        return UIImage(named: "HappySelectedIcon")!
    case Mood.neutral.rawValue:
        return UIImage(named: "NeutralSelectedIcon")!
    case Mood.sad.rawValue:
        return UIImage(named: "SadSelectedIcon")!
    case Mood.verySad.rawValue:
        return UIImage(named: "VSadSelectedIcon")!
    default: return UIImage(named: "VHappySelectedIcon")!;
    }
}

func getEntryMoodText(_ entry: Entry) -> String{
    switch (entry.mood){
    case Mood.veryHappy.rawValue:
        return "Sangat senang"
    case Mood.happy.rawValue:
        return "Senang"
    case Mood.neutral.rawValue:
        return "Biasa saja"
    case Mood.sad.rawValue:
        return "Sedih"
    case Mood.verySad.rawValue:
        return "Sangat sedih"
    default: return "";
    }
}
