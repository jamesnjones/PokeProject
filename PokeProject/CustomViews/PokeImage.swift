//
//  PokeImage.swift
//  PokeProject
//
//  Created by james Jones on 20/06/2022.
//

import UIKit

//Custom Image
class PokeImage: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true // this allows the picture inside to also have rounded edges
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    init(imageName: String) {
        super.init(frame: .zero)
        self.image = UIImage(systemName: imageName)
        self.tintColor = .lightGray
        configure()
    }

}
