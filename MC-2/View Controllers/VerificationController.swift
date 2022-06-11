//
//  VerificationController.swift
//  MC-2
//
//  Created by melvin on 10/06/22.
//

import UIKit
import FirebaseAuth

class VerificationController: UIViewController {

    @IBOutlet weak var verifLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userEmail = Auth.auth().currentUser?.email else {
            // some code
            return
        }
        
        verifLabel.text="Silahkan cek link verifikasi email yang sudah kami kirim ke \(userEmail)"
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.tintColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.topItem!.title = ""

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            let loginViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as? LogInViewController
            
            view.window?.rootViewController = loginViewController
            view.window?.makeKeyAndVisible()
        }
    }
    


}
