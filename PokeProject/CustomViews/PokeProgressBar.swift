//
//  PokeProgressBar.swift
//  PokeProject
//
//  Created by james Jones on 20/06/2022.
//

import UIKit
// Custom Progress bar for showing how powerful pokemons move is 
class PokeProgressBar: UIProgressView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.tintColor =  self.progress <= 0.60 ? .green : .red
        self.progress = 0.0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

}
