//
//  Alert+EXT.swift
//  PokeProject
//
//  Created by james Jones on 22/08/2021.
//

import UIKit

extension UIViewController {
    // A simple extension to help with repeatable code when presenting alerts
    
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
     DispatchQueue.main.async {
         let alertVC = PokeAlert(title: title, message: message, buttonTitle: buttonTitle)
         alertVC.modalPresentationStyle = .overFullScreen
         alertVC.modalTransitionStyle = .crossDissolve
         self.present(alertVC, animated: true, completion: nil)
        }
     }
}
