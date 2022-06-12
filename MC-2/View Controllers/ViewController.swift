//
//  ViewController.swift
//  MC-2
//
//  Created by melvin on 30/05/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var onboardImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardImage.image = UIImage(named: "onboardImage")
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1)
        signUpButton.layer.cornerRadius = 10
        
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)]
        gradient.frame = signUpButton.bounds
        signUpButton.layer.insertSublayer(gradient, at: 0)
        signUpButton.layer.masksToBounds = true;
    }


}

