//
//  VerificationController.swift
//  MC-2
//
//  Created by melvin on 10/06/22.
//

import UIKit
import FirebaseAuth


extension UILabel {

    public var fullRange: NSRange { return NSMakeRange(0, text?.count ?? 0) }

    public func range(string: String) -> NSRange? {
        let range = NSString(string: forceText).range(of: string)
        return range.location != NSNotFound ? range : nil
    }

    public func range(after string: String) -> NSRange? {
        guard var range = range(string: string) else { return nil }
        range.location = range.location + range.length
        range.length = forceText.count - range.location
        return range
    }

    public func range(before string: String) -> NSRange? {
        guard var range = range(string: string) else { return nil }
        range.length = range.location
        range.location = 0
        return range
    }

    public func range(after: String, before: String) -> NSRange? {
        guard let rAfter = range(after: after),
            let rBefore = range(before: before),
            rAfter.location < rBefore.length
            else { return nil }
        return NSMakeRange(rAfter.location, rBefore.length - rAfter.location)
    }

    public func range(fromBeginningOf string: String) -> NSRange? {
        guard var range = range(string: string) else { return nil }

        range.length = forceText.count - range.location
        return range
    }

    public func range(untilEndOf string: String) -> NSRange? {
        guard var range = range(string: string) else { return nil }
        range.length = range.location + range.length
        range.location = 0
        return range
    }

    public func range(fromBeginningOf beginString: String, untilEndOf endString: String) -> NSRange? {
        guard let rBegin = range(fromBeginningOf: beginString),
            let rEnd = range(untilEndOf: endString),
            rBegin.location < rEnd.length
            else { return nil }
        return NSMakeRange(rBegin.location, rEnd.length - rBegin.location)
    }

    // MARK: Range Formatter
    public func set(textColor: UIColor, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString
        text.addAttribute(.foregroundColor, value: textColor, range: range)
        attributedText = text
    }

    public func set(font: UIFont, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString
        text.addAttribute(.font, value: font, range: range)
        attributedText = text
    }

    public func set(underlineColor: UIColor, range: NSRange?, byWord: Bool = false) {
        guard let range = range else { return }
        let text = mutableAttributedString
        var style = NSUnderlineStyle.single.rawValue
        if byWord { style = style | NSUnderlineStyle.byWord.rawValue }
        text.addAttribute(.underlineStyle, value: NSNumber(value: style), range: range)
        text.addAttribute(.underlineColor, value: underlineColor, range: range)
        attributedText = text
    }

    public func setTextWithoutUnderline(_ range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString
        text.removeAttribute(.underlineStyle, range: range)
        attributedText = text
    }

    // MARK: Helpers
    private var forceText: String { return text ?? "" }

    private var mutableAttributedString: NSMutableAttributedString {
        if let attr = attributedText {
            return NSMutableAttributedString(attributedString: attr)
        } else {
            return NSMutableAttributedString(string: forceText)
        }
    }
}

class VerificationController: UIViewController {

    @IBOutlet weak var verifLabel: UILabel!
    var userEmail: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        verifLabel.text="Silahkan cek link verifikasi email yang sudah kami kirim ke \(userEmail.lowercased())"
        verifLabel.textColor = UIColor.darkGray
        verifLabel.set(textColor: UIColor.black , range: NSMakeRange(60, userEmail.count))
        
        
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
