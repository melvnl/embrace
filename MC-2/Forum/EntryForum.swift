//
//  EntryForum.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 16/06/22.
//

import Foundation
import UIKit

struct EntryForum{
    var id = ""
    var title = ""
    var desc = ""
    var category = 0
    var date = Date.now
    var user_id = ""
    var image = EMPTY_IMAGE
}

func getEntryCategoryText(_ entry: EntryForum) -> String{
    switch (entry.category){
    case KEHAMILAN:
        return "Kehamilan"
    case PERAWATAN_BAYI:
        return "Perawatan Bayi"
    case KESEHATAN_MENTAL:
        return "Kesehatan Mental"
    case PASCA_MELAHIRKAN:
        return "Pasca Melahirkan"
    case PENGASUHAN_ANAK:
        return "Pengasuhan Anak"
    case LAINNYA:
        return "Lainnya"
    default: return "";
    }
}
