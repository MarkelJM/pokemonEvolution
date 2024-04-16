//
//  ListDataManager.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import Foundation
import UIKit

class ListDataManager {
    private let apiManager = PokeApiManager()
    
    func fetchPokemonList(completion: @escaping (Result<[PokemonBusinessModel], Error>) -> Void) {
        apiManager.fetchPokemonList { result in
            switch result {
            case .success(let pokemonListItems):
                let businessModels = pokemonListItems.map {
                    let id = Int($0.url.split(separator: "/").last ?? "") ?? 0
                    return PokemonBusinessModel(
                        id: id,
                        name: $0.name.capitalized,
                        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png",
                        weight: 0, 
                        height: 0,
                        abilities: [], 
                        evolutions: []
                    )
                }
                completion(.success(businessModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        apiManager.fetchImage(from: urlString, completion: completion)
    }
}

