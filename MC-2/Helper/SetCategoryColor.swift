//
//  SetCategoryColor.swift
//  MC-2
//
//  Created by melvin on 28/06/22.
//

import Foundation
import UIKit

extension UIButton{
    func setCategoryColor(_ category: String){
        
        switch category {
            case "Kehamilan":
                self.backgroundColor = UIColor(red: 255/255, green: 237/255, blue: 240/255, alpha: 1)
                self.layer.masksToBounds = true;
                self.setTitleColor(UIColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), for: .normal)
            
            case "Perawatan Bayi":
                self.backgroundColor = UIColor(red: 255/255, green: 245/255, blue: 231/255, alpha: 1)
                self.layer.masksToBounds = true;
                self.setTitleColor(UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 1), for: .normal)
            
            case "Kesehatan Mental":
                self.backgroundColor = UIColor(red: 233/255, green: 244/255, blue: 235/255, alpha: 1)
                self.setTitleColor(UIColor(red: 32/255, green: 149/255, blue: 51/255, alpha: 1), for: .normal)
            
            case "Pasca Melahirkan":
                self.backgroundColor = UIColor(red: 237/255, green: 254/255, blue: 255/255, alpha: 1)
                self.setTitleColor(UIColor(red: 22/255, green: 176/255, blue: 186/255, alpha: 1), for: .normal)
            
            case "Pengasuhan Anak":
                self.backgroundColor = UIColor(red: 237/255, green: 239/255, blue: 255/255, alpha: 1)
                self.setTitleColor(UIColor(red: 77/255, green: 95/255, blue: 255/255, alpha: 1), for: .normal)
            
            case "Lainnya":
                self.backgroundColor = UIColor(red: 247/255, green: 237/255, blue: 255/255, alpha: 1)
                self.setTitleColor(UIColor(red: 177/255, green: 77/255, blue: 255/255, alpha: 1), for: .normal)
            default:
                break;
    }
    }
}
