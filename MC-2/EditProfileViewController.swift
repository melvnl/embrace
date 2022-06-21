//
//  EditProfileViewController.swift
//  MC-2
//
//  Created by Vendly on 14/06/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var editProfilBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editProfilBtn.layer.cornerRadius = 10
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)]
        gradient.frame = editProfilBtn.bounds
        editProfilBtn.layer.insertSublayer(gradient, at: 0)
        editProfilBtn.layer.masksToBounds = true;
        
    }
    


}
