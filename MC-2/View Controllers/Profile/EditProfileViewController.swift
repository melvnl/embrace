//
//  EditProfileViewController.swift
//  MC-2
//
//  Created by Vendly on 14/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var editProfilBtn: UIButton!
    @IBOutlet weak var addImgBtn: UIButton!
    @IBOutlet weak var editImg: UIImageView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var descTxtField: UITextField!
    
    private var imgData: Data?
    
    var currProfileEntry: ProfileEntry!
    var isEditingEntry: Bool = false
    
    public var updateProfileCompletion: ((ProfileEntry) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load user profile
        
        usernameTxtField.text = currProfileEntry.username
        nameTxtField.text = currProfileEntry.name
        descTxtField.text = currProfileEntry.description
        editImg.load(url: URL(string: currProfileEntry.avatar)!)
        
        // load image
        
        editProfilBtn.layer.cornerRadius = 10
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)]
        gradient.frame = editProfilBtn.bounds
        editProfilBtn.layer.insertSublayer(gradient, at: 0)
        editProfilBtn.layer.masksToBounds = true;
     
        styleTextField(usernameTxtField)
        styleTextField(nameTxtField)
        styleTextField(descTxtField)
        
//        rounded dismiss button
        dismissBtn.layer.cornerRadius = 0.5 * dismissBtn.bounds.size.width
        dismissBtn.clipsToBounds = true
        
//        hide image
        imgContainer.isHidden = true
        imgContainer.alpha = 0
        
//        show add image button
        addImgBtn.isHidden = false
        addImgBtn.alpha = 1
    }
    
    @IBAction func didTapImgBtn(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.allowsEditing = true
        imgPicker.delegate = self
        present(imgPicker, animated: true)
    }
    
    @IBAction func didTapDismissBtn(_ sender: Any) {
        imgContainer.fadeOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.imgContainer.isHidden = true
            self.addImgBtn.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.addImgBtn.alpha = 1.0
            }
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        show image
        guard let img: UIImage = info[.editedImage] as? UIImage else { return }
        imgData = img.jpegData(compressionQuality: 0.5)
        
        self.editImg.image = img
        
//        fade in
        self.imgContainer.isHidden = false
        self.imgContainer.fadeIn()
        
//        hide add image button
        self.addImgBtn.alpha = 0
        self.addImgBtn.isHidden = true
        
        dismiss(animated: true)
    }
    
    @IBAction func didTapEdit(_ sender: Any) {
        if nameTxtField.text!.isEmpty == false && descTxtField.text!.isEmpty == false {
            
            var newProfileEntry = ProfileEntry(
                username: self.usernameTxtField.text!,
                name: self.nameTxtField.text!,
                description: self.descTxtField.text!
            )
            
            uploadImage { [self] imgUrl in
                newProfileEntry.avatar = imgUrl!
                
                if imgContainer.isHidden && currProfileEntry.avatar != DEFAULT_AVATAR {
                    
                    let f = "profile/" + Auth.auth().currentUser!.uid + ".jpg"
                    let ref = Storage.storage().reference().child(f)

                    ref.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            print("Old image has been removed!")
                        }
                    }

                }

                updateProfileCompletion!(newProfileEntry)
            }
            
        }
    }
    
    func uploadImage(completion: @escaping((String?) -> () )) {
        if imgContainer.isHidden == false {
            let md = StorageMetadata()
            md.contentType = "image/png"

            let f = "profile/" + Auth.auth().currentUser!.uid + ".jpg"
            let ref = Storage.storage().reference().child(f)
            
            ref.putData(imgData!, metadata: md) { (metadata, error) in
                if error == nil {
                    ref.downloadURL(completion: { (url, error) in
                        completion(String(describing: url!))
                    })
                } else {
                    print("error \(String(describing: error))")
                }
            }
            
        } else {
            completion(DEFAULT_AVATAR)
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
    
}
