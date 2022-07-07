//
//  EntryViewController.swift

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var moodDropDown: DropDown!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    
    public var completion: ((Entry) -> Void)?
    public var updateCompletion: ((Entry) -> Void)?
    private var selectedMood = 0

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageDismissButton: UIButton!

    @IBOutlet weak var saveButton: UIButton!
    
    private var imgData: Data?
    
    // Variables for editing
    var currEntry: Entry!
    var isEditingEntry: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.becomeFirstResponder()
        navigationItem.largeTitleDisplayMode = .never
        
        saveButton.layer.shadowColor = CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)
        saveButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        saveButton.layer.shadowOpacity = 1.0
        saveButton.layer.shadowRadius = 1.0
        
        saveButton.layer.cornerRadius = 10
        let gradient = CAGradientLayer()
        gradient.colors = [CGColor(red: 255/255, green: 77/255, blue: 109/255, alpha: 1), CGColor(red: 208/255, green: 46/255, blue: 75/255, alpha: 1)]
        gradient.frame = saveButton.bounds
        saveButton.layer.insertSublayer(gradient, at: 0)
        saveButton.layer.masksToBounds = true;
        
        // Change text field broders
        styleTextField(moodDropDown)
        styleTextField(titleField)
        styleTextField(descField)
        
        // Setup dropdown menu
        // The list of array to display. Can be changed dynamically
        moodDropDown.optionArray = ["Sangat senang", "Senang", "Biasa saja", "Sedih", "Sangat Sedih"]
        // Its Id Values and its optional
        moodDropDown.optionIds = [Mood.veryHappy.rawValue, Mood.happy.rawValue, Mood.neutral.rawValue, Mood.sad.rawValue, Mood.verySad.rawValue]
        
        moodDropDown.didSelect{(selectedText , index ,id) in
            self.selectedMood = id
        }
        
        // Setup image dismiss button
        imageDismissButton.layer.cornerRadius = 0.5 * imageDismissButton.bounds.size.width
        imageDismissButton.clipsToBounds = true
        
        // Hide image
        imageContainer.isHidden = true
        imageContainer.alpha = 0
        
        // Show add image button
        addImageButton.isHidden = false
        addImageButton.alpha = 1
        
        // Remove back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        
        // Check if editing entry
        if(isEditingEntry){
            loadEntryFields()
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func loadEntryFields(){
        // fill title, desc, mood
        titleField.text = currEntry.title
        descField.text = currEntry.desc
        moodDropDown.selectedIndex = currEntry.mood-1
        moodDropDown.text = getEntryMoodText(currEntry)
        selectedMood = currEntry.mood
        
        // load image
        if(currEntry.image != EMPTY_IMAGE){
            let url = URL(string: currEntry.image)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    //Hide add image button
                    self.addImageButton.isHidden = true
                    
                    // Fade in image
                    self.image.image = UIImage(data: data!)
                    self.imageContainer.isHidden = false
                    UIView.animate(withDuration: 0.2) {
                        self.imageContainer.alpha = 1.0
                    }
                }
            }
        }
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
            self.addImageButton.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.addImageButton.alpha = 1.0
            }
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Show image
        guard let im: UIImage = info[.editedImage] as? UIImage else { return }
        imgData = im.jpegData(compressionQuality: 0.5)
        
        self.image.image = im
        
        // Fade in
        self.imageContainer.isHidden = false
        self.imageContainer.fadeIn()
        
        // Hide add image button
        self.addImageButton.alpha = 0
        self.addImageButton.isHidden = true
        
        dismiss(animated: true)
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        if titleField.text?.isEmpty == false && descField.text?.isEmpty == false && selectedMood != 0 {
            
            var newEntry = Entry(
               title: self.titleField.text!,
               desc: self.descField.text!,
               mood: selectedMood,
               user_id: Auth.auth().currentUser!.uid
               )
            
            uploadImage{ [self] imgUrl in
                newEntry.image = imgUrl!
                
                if(isEditingEntry == true){
                    // delete old image if imageview is hidden && old image url not empty
                    if(imageContainer.isHidden && currEntry.image != EMPTY_IMAGE){

                        // Create a reference to the file to delete
                        let date = currEntry.date.toString("ddMMyyHHmm")
                        let f = "journal/" + Auth.auth().currentUser!.uid + "_" + date + ".jpg"
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
                    completion?(newEntry)
                }
            }
        }
    }
    
    func uploadImage(completion:@escaping((String?) -> () )){
        if(imageContainer.isHidden == false){
            let md = StorageMetadata()
            md.contentType = "image/png"
            
            let date = isEditingEntry ? currEntry.date.toString("ddMMyyHHmm") : Date.now.toString("ddMMyyHHmm")
            let f = "journal/" + Auth.auth().currentUser!.uid + "_" + date + ".jpg"
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
