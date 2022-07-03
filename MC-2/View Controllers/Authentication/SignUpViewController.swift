//
//  SignUpViewController.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 07/06/22.
//

import UIKit
import FirebaseAuth
import Firebase
import Alamofire

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var namaTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var iconClick = true
    
    let imageIcon = UIImageView()
    
    let dcWebhook = Bundle.main.object(forInfoDictionaryKey: "discord_webhook") as! String

    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.layer.cornerRadius = 10
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)]
        gradient.frame = signUpButton.bounds
        signUpButton.layer.insertSublayer(gradient, at: 0)
        signUpButton.layer.masksToBounds = true;

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.tintColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.topItem!.title = " "
        
        styleTextField(namaTextField)
        
        styleTextField(emailTextField)
        
        styleTextField(usernameTextField)
        
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
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 1)
        
        bottomLine.backgroundColor = UIColor.init(red: 197/255, green: 199/255, blue: 196/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    //validate password
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message.
    func validationFields() -> String? {
        
        // Check that all fields are filled in
        if namaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Tolong isi semua bagian formulir pendaftaran"
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            // Password is not secure enough
            return "Pastikan password minimal terdiri dari 8 karakter, berisi karakter spesial, dan berisi nomor."
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toVerif" {
           guard let secondViewController = segue.destination as? VerificationController else { return }
           // Pass Data to Second View Controller
           secondViewController.userEmail = emailTextField.text ?? ""
       }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String,
                                sender: Any?) -> Bool{
        

        if(identifier == "toVerif"){
            if((validationFields()) != nil) {
                return false
            }
                return true
            }
        else{
            return true
        }
        }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
//        Validate the fields
        let error = validationFields()
        
        if error != nil {
            //there's something wrong with the fields,show error message
            showError(error!)
        }else {
            
            // Create cleaned versions of the data
            let nama = namaTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //  Create the user
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                //Check for errors
                if err != nil {
                    //there was an error creating user
                    let parameters: [String: String] = [
                        "content" : err!.localizedDescription,
                    ]
                    
                    let headers: HTTPHeaders = [
                            "Content-Type": "application/json"
                        ]
                    
                    AF.request(self.dcWebhook, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                                response in
                                switch (response.result) {
                                case .success:
                                    print(response)
                                    break
                                case .failure:
                                    print(Error.self)
                                }
                            }
                    self.showError("Error dalam membuat akun")
                }else {
                    // User was created successfully, now store name & username
                    
                    let user = result?.user
                    let userUid = result?.user.uid
                    
                    user?.sendEmailVerification()
                    
                    let db = Firestore.firestore()
                    //firebaseUid and firestoreUid is diff
//                    db.collection("users").addDocument(data: ["nama":nama, "username":username, "uid":result!.user.uid]) { error in
//                        if error != nil {
//                            //show error message
//                            self.showError("Error dalam menyimpan data akun")
//                        }
//                    }
                    
                    //firebaseUid and firestoreUid is equal
                    db.collection("users").document(userUid ?? "").setData(["nama":nama, "username":username, "uid":result!.user.uid]) { error in
                                                if error != nil {
                                                    //show error message
                                                    self.showError("Error dalam menyimpan data akun")
                                                }
                                            }
                    
                    // Transition to the home screen
                    self.transitionToVerification()
                }
            }
                    
            
        }

    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

    func transitionToLogin() {
        
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as? LogInViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToVerification() {
        
        let verificationController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.verificationViewController) as? VerificationController
        
        view.window?.rootViewController = verificationController
        view.window?.makeKeyAndVisible()
    }
}
