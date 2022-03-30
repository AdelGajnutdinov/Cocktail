//
//  DrinksResponse.swift
//  Cocktail
//
//  Created by Adel Gainutdinov on 29.03.2022.
//

import Foundation

// MARK: - Welcome
struct DrinksResponse: Codable {
    let drinks: [Drink]
}

// MARK: - Drink
struct Drink: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
    }
}

