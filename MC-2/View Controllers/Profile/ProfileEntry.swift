//
//  ProfileEntry.swift
//  MC-2
//
//  Created by Vendly on 16/06/22.
//

import Foundation
import UIKit

let DEFAULT_AVATAR = "https://firebasestorage.googleapis.com/v0/b/embrace-mini-challenge-2.appspot.com/o/avatar.png?alt=media&token=228d6d5e-53b2-461d-886f-90889981a393"

struct ProfileEntry {
    var username = ""
    var name = ""
    var description = ""
    var avatar = DEFAULT_AVATAR
    var saves : [String] = []
}
