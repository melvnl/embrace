//
//  UIView+Fade.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 13/06/22.
//

import Foundation
import UIKit

public extension UIView {

    func fadeIn(duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 1.0 })
    }

    func fadeOut(duration: TimeInterval = 0.2) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 0.0 })
    }

}
