//
//  SearchVC.swift
//  PokeProject
//
//  Created by james Jones on 13/08/2021.
//

import UIKit

class SearchVC: UIViewController {
    
    var pokemon : [Pokemon] = []
    
    private let searchText: UITextField = { // will use a textfield for searching on this occasion as we need the entered text for a network call
        let text = UITextField()
        text.isUserInteractionEnabled = true
        text.textColor = .secondaryLabel
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.masksToBounds = true
        text.layer.borderColor = UIColor.systemGray2.cgColor
        text.layer.borderWidth = 2
        text.layer.cornerRadius = 10
        text.placeholder = " Search Type, fire, water etc...  "
        text.returnKeyType = .search
        text.autocapitalizationType = .words
        text.autocorrectionType = .no
        text.textAlignment = .center
        text.clearButtonMode = .whileEditing
        text.autocapitalizationType = .none
        
        return text
    }()
    
    let tableView : UITableView = {
       let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.identifier)
        tableView.setNeedsLayout()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchText)
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.titleView = searchText
        searchText.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        searchText.delegate = self
   
    }
    
    func pokemonNetworkCall() {
        guard let text = searchText.text, !text.isEmpty else {return}
         
             pokemon = []
        // uses the text we type in to search what type of pokemon should be displayed
        NetworkManager.network.getPokemonType(type: text) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.pokemon.append(contentsOf: results.pokemon!)
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    self.presentAlertOnMainThread(title: K.error, message: error.rawValue, buttonTitle: "OK")
                }
            }
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "-" {
            return true
        }else {
            textField.placeholder = "Search Type, fire, water etc... "
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        pokemonNetworkCall()
        textField.text = ""
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier) as! CustomTableCell
        cell.pokeTitle.text = pokemon[indexPath.row].pokemon.name.capitalized
         
            // to again get the images and display them
                NetworkManager.network.getPokemonInfo(name: pokemon[indexPath.row].pokemon.name) { result in
                    switch result {
                    case .success(let results):
                        cell.pokeImage.downloaded(from: (results.sprites?.front_default) ?? "")
                    case .failure(let error):
                        self.presentAlertOnMainThread(title: K.error, message: error.rawValue, buttonTitle: "OK")
                    }
                }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = PokemonDetailVC()
        destVC.name = pokemon[indexPath.row].pokemon.name
        destVC.title = destVC.name.capitalized // pass data across 

        navigationController?.pushViewController(destVC, animated: true)
    }
}
