//
//  CustomCell.swift
//  PokeProject
//
//  Created by james Jones on 14/08/2021.
//

import UIKit
// Custom CollectionView Cell
class CustomCell: UICollectionViewCell {
    static let identifier = "customCell"
    
    var image : UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.layer.cornerRadius = 10.0
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return image
    }()
    
    var pokeTitle: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(12)
        label.minimumScaleFactor = 0.75
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(pokeTitle)
        contentView.clipsToBounds = true
        contentView.addSubview(image)
        contentView.autoresizesSubviews = false
        image.autoresizesSubviews = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: contentView.height),
            image.widthAnchor.constraint(equalToConstant: contentView.width),
            pokeTitle.widthAnchor.constraint(equalToConstant: contentView.width)
        ])
        
        image.frame = contentView.bounds
        pokeTitle.frame = CGRect(x: 0, y: 0, width: contentView.width, height: 25)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        autoresizesSubviews = false
        image.image = nil
    }
}
