//
//  AddNewForumViewController.swift
//  MC-2
//
//  Created by Stefanus Hermawan Sebastian on 15/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AddNewForumViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public var completion: ((EntryForum) -> Void)?
    public var updateCompletion: ((EntryForum) -> Void)?
    private var selectedCategory = ""
    private var imgData: Data?
    
    // Variables for editing
    var currEntry: EntryForum!
    var isEditingEntry: Bool = false
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var judulTextField: UITextField!
    @IBOutlet weak var tambahGambarButton: UIButton!
    @IBOutlet weak var deskripsiTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var kategoriDropDown: DropDown!
    @IBOutlet weak var simpanForumButton: UIButton!
    @IBOutlet weak var cancelImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        simpanForumButton.layer.shadowColor = CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)
        simpanForumButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        simpanForumButton.layer.shadowOpacity = 1.0
        simpanForumButton.layer.shadowRadius = 1.0
        
        simpanForumButton.layer.cornerRadius = 10
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)]
        gradient.frame = simpanForumButton.bounds
        simpanForumButton.layer.insertSublayer(gradient, at: 0)
        simpanForumButton.layer.masksToBounds = true;
        
        judulTextField.becomeFirstResponder()
        navigationItem.largeTitleDisplayMode = .never
        
        // Change text field broders
        styleTextField(kategoriDropDown)
        styleTextField(judulTextField)
        styleTextField(deskripsiTextField)
        
        // Setup dropdown menu
        // The list of array to display. Can be changed dynamically
        kategoriDropDown.optionArray = [
            Category.KEHAMILAN.rawValue,
            Category.PERAWATAN_BAYI.rawValue,
            Category.KESEHATAN_MENTAL.rawValue,
            Category.PASCA_MELAHIRKAN.rawValue,
            Category.PENGASUHAN_ANAK.rawValue,
            Category.LAINNYA.rawValue
        ]
        
        kategoriDropDown.didSelect{(selectedText , index ,id) in
            self.selectedCategory = selectedText
        }
        
        // Setup image dismiss button
        cancelImageButton.layer.cornerRadius = 0.5 * cancelImageButton.bounds.size.width
        cancelImageButton.clipsToBounds = true
        
        // Hide image
        imageContainer.isHidden = true
        imageContainer.alpha = 0
        
        // Show add image button
        tambahGambarButton.isHidden = false
        tambahGambarButton.alpha = 1
        
        // Remove back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        // Check if editing entry
        if(isEditingEntry){
            loadEntryFields()
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func didTapAddImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func didTapDismissImage(_ sender: Any) {
        imageContainer.fadeOut()
    
        // Wait for fadeout animation to finish
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
            self.imageContainer.isHidden = true
            
            // Show add image button
            self.tambahGambarButton.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.tambahGambarButton.alpha = 1.0
            }
        })
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        if judulTextField.text?.isEmpty == false && deskripsiTextField.text?.isEmpty == false && selectedCategory != "" {
            
            let group = DispatchGroup()
            var currentUser: ProfileEntry?
            group.enter()
            
            DispatchQueue.main.async{
                self.showSpinner(onView: self.view)
                profileRepo.fetchCurrentUser { currUser in
                    currentUser = currUser
                    group.leave()
                }
            }
            
            group.notify(queue: .main){ [self] in
                var newEntry = EntryForum(
                   forumTitle: self.judulTextField.text!,
                   forumDesc: self.deskripsiTextField.text!,
                   category: selectedCategory,
                   authorName: currentUser?.name ?? "",
                   authorUsername: currentUser?.username ?? "",
                   authorAvatar: currentUser?.avatar ?? DEFAULT_AVATAR
                )
                
                uploadImage{ [self] imgUrl in
                    newEntry.forumThumbnail = imgUrl!
                    
                    if(isEditingEntry == true){
                        // delete old image if imageview is hidden && old image url not empty
                        if(imageContainer.isHidden && currEntry.forumThumbnail != EMPTY_IMAGE){

                            // Create a reference to the file to delete
                            let date = generateDateForStorage(currEntry.date)
                            let f = "forum/" + Auth.auth().currentUser!.uid + "_" + date + ".jpg"
                            let ref = Storage.storage().reference().child(f)

                            // Delete the file
                            ref.delete { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    print("Old image deleted successfully")
                                }
                            }
                        }
                        
                        // update entry
                        newEntry.id = currEntry.id
                        updateCompletion?(newEntry)
                    }
                    else{
                        print("error")
                        completion?(newEntry)
                    }
                }
            
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Show image
        guard let im: UIImage = info[.editedImage] as? UIImage else { return }
        imgData = im.jpegData(compressionQuality: 0.5)
        
        self.imageView.image = im
        
        // Fade in
        self.imageContainer.isHidden = false
        self.imageContainer.fadeIn()
        
        // Hide add image button
        self.tambahGambarButton.alpha = 0
        self.tambahGambarButton.isHidden = true
        
        dismiss(animated: true)
    }
    
    func generateDateForStorage(_ date: Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyHHmm"
        return dateFormatter.string(from: date)
    }
    
    func uploadImage(completion:@escaping((String?) -> () )){
        if(imageContainer.isHidden == false){
            let md = StorageMetadata()
            md.contentType = "image/png"
            
            let date = isEditingEntry ? generateDateForStorage(currEntry.date) : generateDateForStorage(Date.now)
            let f = "forum/" + Auth.auth().currentUser!.uid + "_" + date + ".jpg"
            let ref = Storage.storage().reference().child(f)
            
            ref.putData(imgData!, metadata: md) { (metadata, error) in
                if error == nil {
                    ref.downloadURL(completion: { (url, error) in
                        print("Done, url is \(String(describing: url))")
                        completion(String(describing: url!))
                    })
                }else{
                    print("error \(String(describing: error))")
                }
            }
        }
        else{
            completion(EMPTY_IMAGE)
        }
        
    }
    
    
    func loadEntryFields(){
        // fill title, desc, mood
        judulTextField.text = currEntry.forumTitle
        deskripsiTextField.text = currEntry.forumDesc
        kategoriDropDown.selectedIndex = getIndexFromCategory(Category(rawValue: currEntry.category)!)
        kategoriDropDown.text = currEntry.category
        selectedCategory = currEntry.category
        
        // load image
        if(currEntry.forumThumbnail != EMPTY_IMAGE){
            let url = URL(string: currEntry.forumThumbnail)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    //Hide add image button
                    self.tambahGambarButton.isHidden = true
                    
                    // Fade in image
                    self.imageView.image = UIImage(data: data!)
                    self.imageContainer.isHidden = false
                    UIView.animate(withDuration: 0.2) {
                        self.imageContainer.alpha = 1.0
                    }
                }
            }
        }
    }
    
    
    func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width - 25, height: 1)
        
        bottomLine.backgroundColor = UIColor.init(red: 197/255, green: 199/255, blue: 196/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
        
    }
    

    

}
