//
//  PokemonBusinessModel.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import Foundation


struct PokemonBusinessModel {
    let id: Int
    let name: String
    let imageUrl: String
    let weight: Int
    let height: Int
    let abilities: [String]
    var evolutions: [PokemonEvolution] 
}

struct PokemonEvolution {
    let name: String
    let imageUrl: String
}
