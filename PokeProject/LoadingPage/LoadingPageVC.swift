//
//  LoadingPageVC.swift
//  PokeProject
//
//  Created by james Jones on 17/08/2021.
//

import UIKit

class LoadingPageVC: UIViewController {
    
    let actionButton = PokeButton(backgroundColor: .green, title: "Enter")
    let searchImage = PokeImage(imageName: "magnifyingglass")
    let saveImage = PokeImage(imageName: "star")
    let pokeBallImage = PokeImage(imageName: "octagon")
    
    let searchTitle = PokeTitle(textAlignment: .left, fontSize: 20, color: .white)
    let saveTitle = PokeTitle(textAlignment: .left, fontSize: 20, color: .white)
    let catchEmTitle = PokeTitle(textAlignment: .left, fontSize: 20, color: .white)

    let pokeTitle: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .yellow
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.font = UIFont(name: K.fontName, size: 40)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
///        for family in UIFont.familyNames.sorted() {
///          let name = UIFont.fontNames(forFamilyName: family)
///            print(name)
///        }
       // Ive left this in to show how i got the font name for the pokemon font, because its not always the document name.
        
        view.backgroundColor = .black
        
        searchTitle.text = "Search for Pokèmon"
        saveTitle.text = "Save your favourites"
        catchEmTitle.text = "Catch'em All"
        
        VCModel.createTitle(text: pokeTitle)
        configureUI()
        
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside) // adding an action for when button is clicked 
    }
    
   @objc private func actionButtonPressed() {
        dismiss(animated: true)
        UserDefaults.standard.setValue(true, forKey: K.loadingPageSeen) // this will allow us to only show this screen once - the first time they enter the app
    }
    
    private func configureUI() {
        // i prefer to move the add subviews out of view did load for a cleaner and easier to read codebase
        view.addSubview(pokeTitle)
        view.addSubview(actionButton)
        view.addSubview(searchImage)
        view.addSubview(saveImage)
        view.addSubview(pokeBallImage)
        view.addSubview(searchTitle)
        view.addSubview(saveTitle)
        view.addSubview(catchEmTitle)
        
        // setting constraints
        NSLayoutConstraint.activate([
            pokeTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.width / 2.5),
            pokeTitle.widthAnchor.constraint(equalTo: view.widthAnchor),
            pokeTitle.heightAnchor.constraint(equalToConstant: 50),
            
            searchImage.topAnchor.constraint(equalTo: pokeTitle.bottomAnchor, constant: 50),
            searchImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            searchImage.widthAnchor.constraint(equalToConstant: 40),
            searchImage.heightAnchor.constraint(equalToConstant: 45),
            
            searchTitle.topAnchor.constraint(equalTo: pokeTitle.bottomAnchor, constant: 50),
            searchTitle.leadingAnchor.constraint(equalTo: searchImage.trailingAnchor, constant: 30),
            searchImage.heightAnchor.constraint(equalToConstant: 45),
            
            saveImage.topAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: 30),
            saveImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveImage.widthAnchor.constraint(equalToConstant: 40),
            saveImage.heightAnchor.constraint(equalToConstant: 45),
            
            saveTitle.topAnchor.constraint(equalTo: searchImage.bottomAnchor, constant: 30),
            saveTitle.leadingAnchor.constraint(equalTo: saveImage.trailingAnchor, constant: 30),
            saveTitle.heightAnchor.constraint(equalToConstant: 45),
            
            pokeBallImage.topAnchor.constraint(equalTo: saveImage.bottomAnchor, constant: 30),
            pokeBallImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pokeBallImage.widthAnchor.constraint(equalToConstant: 40),
            pokeBallImage.heightAnchor.constraint(equalToConstant: 45),
            
            catchEmTitle.topAnchor.constraint(equalTo: saveImage.bottomAnchor, constant: 30),
            catchEmTitle.leadingAnchor.constraint(equalTo: pokeBallImage.trailingAnchor, constant: 30),
            catchEmTitle.heightAnchor.constraint(equalToConstant: 45),
            
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalToConstant: view.width / 2),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
