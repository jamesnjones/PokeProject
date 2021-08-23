//
//  PokeButton.swift
//  PokeProject
//
//  Created by james Jones on 17/08/2021.
//

import UIKit
// Custom Button
class PokeButton: UIButton {
 
        override init(frame: CGRect) {     // programatically creating a button
            super.init(frame: frame)
         configure()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")   // this error is cos we dont have storyboard, otherwise we write stuff here
        }
        
        init(backgroundColor: UIColor, title: String){
            super.init(frame: .zero)
            self.backgroundColor = backgroundColor
            self.setTitle(title, for: .normal)
            configure()
        }
        
        private func configure() {    // private cos we dont want this called at all outside this class
            
            layer.cornerRadius = 10
            setTitleColor(.white, for: .normal) // white is default colour anyway but still good to know
            titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
            titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            translatesAutoresizingMaskIntoConstraints = false // use auto layout     // this are like our defaults for the buttons
            
        }
        
        func set(backgroundColor: UIColor, title: String) {
            self.backgroundColor = backgroundColor
            setTitle(title, for: .normal)
    }
}
