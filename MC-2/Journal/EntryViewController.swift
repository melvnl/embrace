//
//  EntryViewController.swift

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EntryViewController: UIViewController {
    
    @IBOutlet weak var moodDropDown: DropDown!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    
    public var completion: ((Entry) -> Void)?
    private var selectedMood = 0

    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var imageDismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.becomeFirstResponder()
        title = "Buat jurnal"
        navigationItem.largeTitleDisplayMode = .never
        
        // Change text field broders
        styleTextField(moodDropDown)
        styleTextField(titleField)
        styleTextField(descField)
        
        // Setup dropdown menu
        // The list of array to display. Can be changed dynamically
        moodDropDown.optionArray = ["Sangat senang", "Senang", "Biasa saja", "Sedih", "Sangat Sedih"]
        // Its Id Values and its optional
        moodDropDown.optionIds = [MOOD_VHAPPY, MOOD_HAPPY, MOOD_NORMAL, MOOD_SAD, MOOD_VSAD]
        
        moodDropDown.didSelect{(selectedText , index ,id) in
            self.selectedMood = id
        }
        
        // Setup image dismiss button
        imageDismissButton.layer.cornerRadius = 0.5 * imageDismissButton.bounds.size.width
        imageDismissButton.clipsToBounds = true
        
        // Hide image
        imageView.isHidden = true
        imageView.alpha = 0
        
        // Remove back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }

    @IBAction func didTapAddImage(_ sender: Any) {
        imageView.isHidden = false
        imageView.fadeIn()
    }
    
    @IBAction func didTapDismissImage(_ sender: Any) {
        imageView.fadeOut()
        // Wait for fadeout animation to finish
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.imageView.isHidden = true
        })
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        if titleField.text?.isEmpty == false && descField.text?.isEmpty == false && selectedMood != 0 {
            let newEntry = Entry(
                title: self.titleField.text!,
                desc: self.descField.text!,
                mood: selectedMood,
                user_id: Auth.auth().currentUser!.uid
                )
            completion?(newEntry)
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
