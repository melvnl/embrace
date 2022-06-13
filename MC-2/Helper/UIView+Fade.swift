//
//  UIView+Fade.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 13/06/22.
//

import Foundation
import UIKit

public extension UIView {

/**
 Fade in a view with a duration
 
 - parameter duration: custom animation duration
 */
    func fadeIn(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 1.0 })
    }

/**
 Fade out a view with a duration
 
 - parameter duration: custom animation duration
 */
    func fadeOut(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { self.alpha = 0.0 })
    }

}
