//
//  BarButtonItem+TitleLabel.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 24/06/22.
//

import Foundation
import UIKit

extension UIViewController{
    func setBarTitle(_ title: String){
        let titleLabel = UIButton(type: UIButton.ButtonType.system)
        titleLabel.setTitle(title, for: UIControl.State.normal)
        titleLabel.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.semibold)
        titleLabel.tintColor = .black
        titleLabel.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
}
