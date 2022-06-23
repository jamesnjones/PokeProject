//
//  NetworkManager.swift
//  PokeProject
//
//  Created by james Jones on 20/06/2022.
//

import UIKit

struct NetworkManager {
    // create a singletton - easier to reference this way than creating a new instance everywhere
    static let network = NetworkManager()
    
    // will be used to return the inital list of pokemon on the main screen
    func getPokemon(endpoint: String, completed: @escaping (Result<User, PokeError>) -> Void) {
        // Used my custom PokeError instead of standand one in order to use my custom Alert messages
        
        let endPoint = "https://pokeapi.co/api/v2/\(endpoint)"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidAPI))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemon = try decoder.decode(User.self, from: data)
                
                completed(.success(pokemon))
                
                
            }catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // This will be used to get all other information for Pokemon, Images, Abilities etc 
    func getPokemonInfo(name: String, completed: @escaping (Result<User, PokeError>) -> Void) {
        let endPoint = "https://pokeapi.co/api/v2/pokemon/\(name)/"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidAPI))
            return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemon = try decoder.decode(User.self, from: data)
                
                completed(.success(pokemon))
                
            }catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    // This will be used when searching for types of Pokemon, Fire, Water etc and then display those results in a tableview
    func getPokemonType(type: String, completed: @escaping (Result<User, PokeError>) -> Void) {
        let endPoint = "https://pokeapi.co/api/v2/type/\(type)/"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidAPI))
            return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemon = try decoder.decode(User.self, from: data)
                
                completed(.success(pokemon))
                
            }catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
