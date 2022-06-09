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
    }


}

