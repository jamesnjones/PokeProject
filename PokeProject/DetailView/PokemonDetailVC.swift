//
//  PokemonDetailVC.swift
//  PokeProject
//
//  Created by james Jones on 20/06/2022.
//

import UIKit
import CoreData

class PokemonDetailVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pokemonEntity: [PokemonEntity]?  // reference to core data database
    
    var caught: Bool = false  // will use to check whether we have a pokemon saved or not
    var name: String = ""
    var results: [User] = []
    
    var hpTitle = PokeTitle(textAlignment: .left, fontSize: 20, color: .darkText)
    var attackTitle = PokeTitle(textAlignment: .left, fontSize: 20, color: .darkText)
    var defenceTitle = PokeTitle(textAlignment: .left, fontSize: 20, color: .darkText)
    var speedTitle = PokeTitle(textAlignment: .left, fontSize: 20, color: .darkText)
    var funFactTitle = PokeTitle(textAlignment: .left, fontSize: 20, color: .darkText)
    var movesTitle = PokeTitle(textAlignment: .left, fontSize: 30, color: .darkText)
    
    var hpImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 10.0
        image.image = UIImage(systemName: "heart.circle")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderColor = UIColor.black.cgColor
        
        return image
    }()
    
    var attackImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 10.0
        image.image = UIImage(systemName: "hammer.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderColor = UIColor.black.cgColor
        
        return image
    }()
    
    var defenceImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 10.0
        image.image = UIImage(systemName: "shield.slash.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderColor = UIColor.black.cgColor
        
        return image
    }()
    
    var speedImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 10.0
        image.image = UIImage(systemName: "bolt.circle")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderColor = UIColor.black.cgColor
        
        return image
    }()
    
    var hpBar = PokeProgressBar(progressViewStyle: .bar)
    var attackBar = PokeProgressBar(progressViewStyle: .bar)
    var defenceBar = PokeProgressBar(progressViewStyle: .bar)
    var speedBar = PokeProgressBar(progressViewStyle: .bar)
    
    var moveOne = PokeTitle(textAlignment: .center, fontSize: 20, color: .darkText)
    var moveTwo = PokeTitle(textAlignment: .center, fontSize: 20, color: .darkText)
    
    var catchButton = PokeButton(backgroundColor: .darkText, title: "Catch")
    
    var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 10.0
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = #colorLiteral(red: 0.9408692718, green: 0.9341481328, blue: 0.9460163713, alpha: 1)
        image.layer.borderColor = UIColor.black.cgColor
        
        return image
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8399531245, green: 0.973993957, blue: 0.9975169301, alpha: 1)
        view.layer.cornerRadius = 15.0
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        catchButton.addTarget(self, action: #selector(catchButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPokemon()
        configureUI()
        
        self.catchButton.setTitle(UserDefaults.standard.bool(forKey: name) ? "Caught" : "Catch" , for: .normal)
        // Ternary operater to decide what text should be
    }
    
    @objc func catchButtonPressed() {
        DispatchQueue.main.async { [self] in

            if !UserDefaults.standard.bool(forKey: name) {
                    // If false this pokemone is not saved, so go ahead and save but if true then nothing will happen.
                    // This will make sure we dont allow users to add duplicates of the same pokemon
            saveData(name: name, url: (results[0].sprites?.front_default)!)
                self.presentAlertOnMainThread(title: "Caught ⭐️", message: "You successfully caught \(name)", buttonTitle: "Ok")
                self.catchButton.setTitle(UserDefaults.standard.bool(forKey: name) ? "Caught" : "Catch" , for: .normal)
            }else {
                self.presentAlertOnMainThread(title: "Added Already", message: "Go catch some new Pokemon", buttonTitle: "OK")
                // simple alert just to let them know they have already added this pokemon
            }
        }
    }
    
    func saveData(name: String, url : String) {
        let newPokemon = PokemonEntity(context: self.context) // creating new instance of PokemonEntity
        newPokemon.name = name // setting its details
        newPokemon.imageURL = url
        
            do {
                try self.context.save() // saving to database
                UserDefaults.standard.setValue(true, forKey: name) // set this to true so it cant be added again
            }catch {
                print(error.localizedDescription)
            }
    }
    
    private func getFact(id: Int) {
        NetworkManager.network.getPokemon(endpoint: "characteristic/\(String(describing: id))/") { [self] resultss in
            switch resultss {
            case .success(let funFact):
                DispatchQueue.main.async { [self] in
                    funFactTitle.text = "Fun Fact: " + (funFact.descriptions?[7].description ?? "N/a")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    funFactTitle.text = "Fun Fact: N/a"
                }
                // There isnt always a fun fact so this will show when that is not available but the app will still work and
                // function i.e saving your favourites.
                // Something i would improve on with more time.
                // will keep alert there to show how my custom alert is designed.
             self.presentAlertOnMainThread(title: K.error, message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func getPokemon() {
        NetworkManager.network.getPokemonInfo(name: name) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let results):
                    self.results.append(results)
                    
                    self.image.downloaded(from: (results.sprites?.front_default)!)
                    moveOne.text = results.abilities?[0].ability.name
                    if results.abilities?.count == 1 {
                        moveTwo.text = "Run Away"
                    }else {
                        moveTwo.text = results.abilities?[1].ability.name
                    } // Some pokemon only had 1 move ability so i wrote some logic so if that is the case the second will default
                        // to Run Away instead of crashing
                 
                    hpTitle.text =  "\((results.stats?[0].base_stat ?? 0))"
                    hpBar.progress = Float(results.stats?[0].base_stat ?? 0) / 100
                    hpBar.tintColor = hpBar.progress > 0.6 ? .green : .red
                    
                    attackTitle.text = "\(String(results.stats?[1].base_stat ?? 0))"
                    attackBar.progress = Float(results.stats?[1].base_stat ?? 0) / 100
                    attackBar.tintColor = attackBar.progress > 0.6 ? .green : .red
                    
                    defenceTitle.text = "\(String(results.stats?[2].base_stat ?? 0))"
                    defenceBar.progress = Float(results.stats?[2].base_stat ?? 0) / 100
                    defenceBar.tintColor = defenceBar.progress > 0.6 ? .green : .red
                    
                    speedTitle.text = "\(String(results.stats?[3].base_stat ?? 0))"
                    speedBar.progress = Float(results.stats?[3].base_stat ?? 0) / 100
                    speedBar.tintColor = speedBar.progress > 0.6 ? .green : .red
                    
                    // Setting the results i get for base stats to their titles
                    // Definitely would improve and refactor this with more time
                    
                    getFact(id: results.id ?? 1)
                    
                case .failure(let error):
                self.presentAlertOnMainThread(title: K.error, message: error.rawValue, buttonTitle: "OK")
                }
            }
        }
    }
    
    func configureUI() {
        view.addSubview(containerView)
        view.addSubview(image)
        containerView.addSubview(hpTitle)
        containerView.addSubview(attackTitle)
        containerView.addSubview(defenceTitle)
        containerView.addSubview(speedTitle)
        
        containerView.addSubview(hpImage)
        containerView.addSubview(attackImage)
        containerView.addSubview(defenceImage)
        containerView.addSubview(speedImage)
        
        containerView.addSubview(hpBar)
        containerView.addSubview(attackBar)
        containerView.addSubview(defenceBar)
        containerView.addSubview(speedBar)
        
        containerView.addSubview(funFactTitle)
        
        containerView.addSubview(moveOne)
        containerView.addSubview(moveTwo)
        
        containerView.addSubview(catchButton)
        
        containerView.addSubview(movesTitle)
        movesTitle.text = "Moves"
        
        moveOne.layer.borderWidth = 1
        moveOne.layer.borderColor = UIColor.black.cgColor
        
        moveTwo.layer.borderWidth = 1
        moveTwo.layer.borderColor = UIColor.black.cgColor
        
        NSLayoutConstraint.activate([
            
            // with more time i would spend a lot longer making sure these were not hard coded and more specific to the view, 
            
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            image.heightAnchor.constraint(equalToConstant: view.width / 1.7),
            
            containerView.topAnchor.constraint(equalTo: image.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            hpImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            hpImage.heightAnchor.constraint(equalToConstant: 20),
            hpImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            hpTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            hpTitle.heightAnchor.constraint(equalToConstant: 20),
            hpTitle.leadingAnchor.constraint(equalTo: hpImage.trailingAnchor, constant: 8),
            
            hpBar.centerYAnchor.constraint(equalTo: hpTitle.centerYAnchor),
            hpBar.leadingAnchor.constraint(equalTo: hpTitle.trailingAnchor, constant: 30),
            hpBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            hpBar.heightAnchor.constraint(equalToConstant: 5),
            
            attackImage.topAnchor.constraint(equalTo: hpTitle.bottomAnchor, constant: 13),
            attackImage.heightAnchor.constraint(equalToConstant: 20),
            attackImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            attackTitle.topAnchor.constraint(equalTo: hpTitle.bottomAnchor, constant: 13),
            attackTitle.heightAnchor.constraint(equalToConstant: 20),
            attackTitle.leadingAnchor.constraint(equalTo: attackImage.trailingAnchor, constant: 8),
            
            attackBar.centerYAnchor.constraint(equalTo: attackTitle.centerYAnchor),
            attackBar.leadingAnchor.constraint(equalTo: attackTitle.trailingAnchor, constant: 30),
            attackBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            attackBar.heightAnchor.constraint(equalToConstant: 5),
            
            defenceImage.topAnchor.constraint(equalTo: attackTitle.bottomAnchor, constant: 13),
            defenceImage.heightAnchor.constraint(equalToConstant: 20),
            defenceImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            defenceTitle.topAnchor.constraint(equalTo: attackTitle.bottomAnchor, constant: 13),
            defenceTitle.heightAnchor.constraint(equalToConstant: 20),
            defenceTitle.leadingAnchor.constraint(equalTo: defenceImage.trailingAnchor, constant: 8),
            
            defenceBar.centerYAnchor.constraint(equalTo: defenceTitle.centerYAnchor),
            defenceBar.leadingAnchor.constraint(equalTo: defenceTitle.trailingAnchor, constant: 30),
            defenceBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            defenceBar.heightAnchor.constraint(equalToConstant: 5),
            
            speedImage.topAnchor.constraint(equalTo: defenceTitle.bottomAnchor, constant: 13),
            speedImage.heightAnchor.constraint(equalToConstant: 20),
            speedImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            speedTitle.topAnchor.constraint(equalTo: defenceTitle.bottomAnchor, constant: 13),
            speedTitle.heightAnchor.constraint(equalToConstant: 20),
            speedTitle.leadingAnchor.constraint(equalTo: speedImage.trailingAnchor, constant: 8),
            
            speedBar.centerYAnchor.constraint(equalTo: speedTitle.centerYAnchor),
            speedBar.leadingAnchor.constraint(equalTo: speedTitle.trailingAnchor, constant: 30),
            speedBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            speedBar.heightAnchor.constraint(equalToConstant: 5),
            
            funFactTitle.topAnchor.constraint(equalTo: speedTitle.bottomAnchor, constant: 13),
            funFactTitle.heightAnchor.constraint(equalToConstant: 23),
            funFactTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            movesTitle.topAnchor.constraint(equalTo: funFactTitle.bottomAnchor, constant: 35),
            movesTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            movesTitle.heightAnchor.constraint(equalToConstant: 30),
            
            moveOne.topAnchor.constraint(equalTo: movesTitle.bottomAnchor, constant: 30),
            moveOne.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 45),
            moveOne.heightAnchor.constraint(equalToConstant: 35),
            moveOne.widthAnchor.constraint(equalToConstant: 135),
            
            moveTwo.topAnchor.constraint(equalTo: movesTitle.bottomAnchor, constant: 30),
            moveTwo.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -45),
            moveTwo.heightAnchor.constraint(equalToConstant: 35),
            moveTwo.widthAnchor.constraint(equalToConstant: 135),
            
            catchButton.topAnchor.constraint(equalTo: moveOne.bottomAnchor,constant: 45),
            catchButton.heightAnchor.constraint(equalToConstant: 40),
            catchButton.widthAnchor.constraint(equalToConstant: view.width / 2),
            catchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
