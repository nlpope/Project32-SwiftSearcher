//  File: UIViewController+Ext.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit

extension UIViewController
{
    func presentSSAlertOnMainThread(alertTitle: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
            let action1 = UIAlertAction(title: buttonTitle, style: .default)
            ac.modalPresentationStyle = .overFullScreen
            ac.modalTransitionStyle = .crossDissolve
            ac.addAction(action1)
            
            self.present(ac, animated: true)
        }
    }
    
    //-------------------------------------//
    // MARK: - SOLVE FOR KEYBOARD BLOCKING TEXTFIELD (by SwiftArcade)
    
    /**
     * FINALLY, MOVE BELOW LINKS TO APP DELEGATE NOTES SECTION > SOURCES
     
     */
    
    func setupKeyboardHiding()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification)
    {
        // get keyboard measurements & currently focused text field location
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              // see note 13 in app delegate
              let currentTextField = UIResponder.currentResponder() as? UITextField else { return }
        
        // check if keyboard top is above text field bottom (relative to superview)
        // see note 14 in app delegate
        let keyboardTopY        = keyboardFrame.cgRectValue.origin.y
        let textFieldBottomY    = currentTextField.frame.origin.y + currentTextField.frame.size.height
        
        // bump view up if so: moving up/left = negative val, moving down/right = positive val
        if textFieldBottomY > keyboardTopY {
            let textFieldTopY   = currentTextField.frame.origin.y
            let newFrameY       = (textFieldTopY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }
    
    
    @objc func keyboardWillHide(sender: NSNotification) { view.frame.origin.y = 0 }
}
