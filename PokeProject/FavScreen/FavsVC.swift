//
//  FavsVC.swift
//  PokeProject
//
//  Created by james Jones on 13/08/2021.
//

import UIKit

class FavsVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // needed to initalise core data
    var pokemonEntity: [PokemonEntity]? // reference to our core data
    
    let tableView : UITableView = {
       let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.identifier)
        tableView.setNeedsLayout()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 1, green: 0.7469804883, blue: 0.3268558979, alpha: 1),
                              NSAttributedString.Key.font: UIFont(name: K.fontName, size: 24)!] as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "MyPokemon"
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        do {
            self.pokemonEntity = try context.fetch(PokemonEntity.fetchRequest()) // this will return all data we have saved in core data
            tableView.reloadData()
        }catch {
            self.presentAlertOnMainThread(title: K.error, message: PokeError.unableToComplete.rawValue, buttonTitle: "OK")
        }
    }
}

extension FavsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemonEntity!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier) as! CustomTableCell
        cell.pokeTitle.text = pokemonEntity![indexPath.row].name
        cell.pokeImage.downloaded(from: pokemonEntity![indexPath.row].imageURL!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = PokemonDetailVC()
        destVC.name = pokemonEntity![indexPath.row].name!
        destVC.title = destVC.name.capitalized
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completionHandler) in
            let pokemonToRemove = self.pokemonEntity![indexPath.row]
            UserDefaults.standard.setValue(false, forKey: pokemonEntity![indexPath.row].name!) // this will make sure we can re-add pokemone at a later date, 
            self.context.delete(pokemonToRemove)
            do {
             try self.context.save()
            } catch {
                print("error")
            }
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
