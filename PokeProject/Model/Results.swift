//
//  Results.swift
//  PokeProject
//
//  Created by james Jones on 14/08/2021.
//

import UIKit
// The structs match the JSON Data in order to correctly get data from servers 
struct User: Codable {
    var results: [Results]?
    var pokemon: [Pokemon]?
    var descriptions: [Descriptions]?
    var id : Int?
    var sprites : Sprites?
    var types: [Types]?
    var stats: [Stats]?
    var abilities: [Abilities]?
}

struct Descriptions: Codable {
    var description: String
}

struct Results: Codable, Hashable {
    var name : String?
    var url: String?
}

struct Pokemon: Codable {
    var pokemon: pokemon
}

struct pokemon: Codable {
    var name: String
}

struct Abilities: Codable {
    var ability: Ability
}

struct Ability: Codable {
    var name: String
}

struct Stats: Codable {
    var base_stat: Int
}

struct Sprites: Codable, Hashable {
    var front_default : String?
}

struct Types: Codable {
    var type: Type
}

struct Type: Codable {
    var name: String
}
