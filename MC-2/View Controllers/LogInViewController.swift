//
//  LogInViewController.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 07/06/22.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var buatAkunButton: UIButton!
    
    var iconClick = true
    
    let imageIcon = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1)
        
        navigationController?.navigationBar.topItem!.title = " "
        
        styleTextField(emailTextField)
        
        styleTextField(passwordTextField)
        
        //closeeye openeye password
        passwordTextField.isSecureTextEntry = true
        imageIcon.image = UIImage(systemName: "eye.slash")
        imageIcon.tintColor = UIColor.systemGray2
        
        let contentView = UIView()
        contentView.addSubview(imageIcon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: Int(UIImage(systemName: "eye.slash")!.size.width), height: Int(UIImage(systemName: "eye.slash")!.size.height))
        
        imageIcon.frame = CGRect(x: -10, y: 0, width: Int(UIImage(systemName: "eye.slash")!.size.width), height: Int(UIImage(systemName: "eye.slash")!.size.height))
        
        passwordTextField.rightView = contentView
        passwordTextField.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(UITapGestureRecognizer:)))
        imageIcon.isUserInteractionEnabled = true
        imageIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(UITapGestureRecognizer:UITapGestureRecognizer) {
        let tappedImage = UITapGestureRecognizer.view as! UIImageView
        
        if iconClick {
            iconClick = false
            tappedImage.image = UIImage(systemName: "eye")
            tappedImage.tintColor = UIColor.systemGray2
            passwordTextField.isSecureTextEntry = false
        }else{
            iconClick = true
            tappedImage.image = UIImage(systemName: "eye.slash")
            tappedImage.tintColor = UIColor.systemGray2
            passwordTextField.isSecureTextEntry = true
        }
    }
    

    func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width - 25, height: 1)
        
        bottomLine.backgroundColor = UIColor.init(red: 197/255, green: 199/255, blue: 196/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    @IBAction func loginTapped(_ sender: Any){
        //TODO : Validate text fields
        
        //Create cleaned versions of the text fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                //Could not signin
                
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }else{
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func buatAkunTapped(_ sender: Any){
//        self.performSegue(withIdentifier: "gotosignup", sender: self)
    }

}
