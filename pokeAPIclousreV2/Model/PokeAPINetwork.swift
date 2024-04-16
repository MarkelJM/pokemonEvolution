//
//  PokeAPINetwork.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//


import Foundation

struct PokemonDetailResponse: Decodable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let abilities: [AbilityEntry]
    let sprites: Sprites

    struct AbilityEntry: Decodable {
        let ability: Ability
        struct Ability: Decodable {
            let name: String
            let url: String
        }
    }

    struct Sprites: Decodable {
        let frontDefault: String

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }

}

struct PokemonListResponse: Decodable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String
}

struct PokemonSpeciesResponse: Decodable {
    let evolutionChain: URLContainer
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
}

struct URLContainer: Decodable {
    let url: String
}



struct EvolutionChainResponse: Decodable {
    let chain: EvolutionLink
}

struct EvolutionLink: Decodable {
    let species: NamedAPIResource
    let evolvesTo: [EvolutionLink]
    
    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}

struct NamedAPIResource: Decodable {
    let name: String
    let url: String
}

