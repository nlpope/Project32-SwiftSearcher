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
}
