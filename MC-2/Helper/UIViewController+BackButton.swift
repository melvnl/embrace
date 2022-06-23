//
//  UIViewController+BackButton.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 14/06/22.
//

import Foundation
import UIKit

public extension UIViewController{
    func setBackBarItem(){
        let backBarItem = UIBarButtonItem()
        backBarItem.title = ""
        backBarItem.tintColor = UIColor.black
        navigationItem.backBarButtonItem = backBarItem
    }
}
