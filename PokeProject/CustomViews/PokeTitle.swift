//
//  PokeTitle.swift
//  PokeProject
//
//  Created by james Jones on 19/08/2021.
//

import UIKit

// Custom UILabel
class PokeTitle: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat, color: UIColor){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        self.textColor = color
        configure()
    }
    
    
   private func configure() {
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.80
    lineBreakMode = .byTruncatingHead
    layer.cornerRadius = 15
    
    translatesAutoresizingMaskIntoConstraints = false
   }
}
