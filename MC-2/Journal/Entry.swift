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
    case MOOD_VHAPPY:
        return UIImage(named: "VHappySelectedIcon")!
    case MOOD_HAPPY:
        return UIImage(named: "HappySelectedIcon")!
    case MOOD_NORMAL:
        return UIImage(named: "NeutralSelectedIcon")!
    case MOOD_SAD:
        return UIImage(named: "SadSelectedIcon")!
    case MOOD_VSAD:
        return UIImage(named: "VSadSelectedIcon")!
    default: return UIImage(named: "VHappySelectedIcon")!;
    }
}

func getEntryMoodText(_ entry: Entry) -> String{
    switch (entry.mood){
    case MOOD_VHAPPY:
        return "Sangat senang"
    case MOOD_HAPPY:
        return "Senang"
    case MOOD_NORMAL:
        return "Biasa saja"
    case MOOD_SAD:
        return "Sedih"
    case MOOD_VSAD:
        return "Sangat sedih"
    default: return "";
    }
}
