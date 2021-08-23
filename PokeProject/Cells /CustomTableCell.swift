//
//  CustomTableCell.swift
//  PokeProject
//
//  Created by james Jones on 20/08/2021.
//

import UIKit
// Custom reuseable tableview cell
class CustomTableCell: UITableViewCell {
    
    static let identifier = "CustomTableCell"
    
    let pokeImage: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .secondaryLabel
        return image
    }()
    
    let pokeTitle: UILabel = {
        let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.lineBreakMode = .byWordWrapping
         label.textColor = .label
         label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
         label.adjustsFontSizeToFitWidth = true
         label.minimumScaleFactor = 0.75
         return label
     }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(pokeImage)
        contentView.addSubview(pokeTitle)
        contentView.backgroundColor = .systemBackground
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(label: String) {
        self.pokeTitle.text = label
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            pokeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            pokeImage.widthAnchor.constraint(equalToConstant: contentView.width / 4),
            pokeImage.heightAnchor.constraint(equalToConstant: contentView.width / 4),
            pokeImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            pokeTitle.leftAnchor.constraint(equalTo: pokeImage.rightAnchor, constant: 10),
            pokeTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        pokeImage.frame = CGRect(x: 3, y: 10, width: contentView.height - 20, height: contentView.height - 20)
        pokeTitle.frame = CGRect(x: pokeImage.right + 40, y: 0, width: contentView.width, height: contentView.height - 5)
    }
}
