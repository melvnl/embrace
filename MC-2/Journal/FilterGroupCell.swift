//
//  FilterGroupCell.swift
//  MC-2
//
//  Created by Tb. Daffa Amadeo Zhafrana on 16/06/22.
//

import Foundation
import Foundation
import UIKit

class FilterGroupCell: UITableViewCell{
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var journalNumberLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        self.contentView.alpha = 0
        UIView.animate(withDuration: 1, animations: { self.contentView.alpha = 1 })
    }
}
