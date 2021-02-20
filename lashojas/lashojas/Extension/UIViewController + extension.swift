//
//  UIViewController + extension.swift
//  lashojas
//
//  Created by Robin Hare on 2/15/21.
//

import UIKit

extension UIViewController {
    
    func appDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func showAlert(title: String, message: String, completion: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
