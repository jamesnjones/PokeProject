//
//  Constants.swift
//  PokeProject
//
//  Created by james Jones on 20/06/2022.
//

import Foundation

// I always create a constant File for any Strings i will be using repeatedly 
struct K {
    static let title = "Pokèmon"
    static let fontName = "PokemonSolidNormal"
    static let loadingPageSeen = "LoadingPageSeen"
    static let error = "Something Went Wrong"
}

enum PokeError: String, Error {
    case invalidAPI = "Please Check API"
    case unableToComplete = "unable to complete request, check internt connection"
    case invalidResponse = "Invalid response from the server, please try again"
    case invalidData = "data recieved caused an error, try again please"
    case unableToFavourite = "error favouriting this user"
    case AlreadyInFavs = "Youve already favourited this user"
}
