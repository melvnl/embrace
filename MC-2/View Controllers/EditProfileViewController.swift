//
//  EditProfileViewController.swift
//  MC-2
//
//  Created by Vendly on 14/06/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var editProfilBtn: UIButton!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var descTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editProfilBtn.layer.cornerRadius = 10
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)]
        gradient.frame = editProfilBtn.bounds
        editProfilBtn.layer.insertSublayer(gradient, at: 0)
        editProfilBtn.layer.masksToBounds = true;
     
        styleTextField(usernameTxtField)
        styleTextField(nameTxtField)
        styleTextField(descTxtField)
    }
    
    @IBAction func backToProfile(_ sender: Any) {
        performSegue(withIdentifier: "unwindProfile", sender: self)
    }
    
    func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor.init(red: 197/255, green: 199/255, blue: 196/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
}
