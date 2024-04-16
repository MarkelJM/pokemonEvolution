//
//  ListDataManagerV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 19/2/24.
//

import Foundation
import Combine
import UIKit

class ListDataManagerV3 {
    private var apiManager = PokeApiManagerV3()

    /*
    //con modelo de red
    func fetchPokemonList() -> AnyPublisher<[PokemonListItem], BaseErrorV3> {
        apiManager.fetchPokemonListCombine()
            .map { response in
                return response.results
            }
            
            .eraseToAnyPublisher()
    }
    */
    func fetchPokemonList() -> AnyPublisher<[PokemonBusinessModel], Error> {
        apiManager.fetchPokemonListCombine()
            .map { response in
                response.results.map { item -> PokemonBusinessModel in
                    // Transformar aquí cada `PokemonListItem` a `PokemonBusinessModel`
                    let id = Int(item.url.split(separator: "/").last ?? "") ?? 0
                    return PokemonBusinessModel(
                        id: id,
                        name: item.name.capitalized,
                        imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png",
                        weight: 0,
                        height: 0,
                        abilities: [],
                        evolutions: []
                    )
                }
            }
            .mapError { error -> BaseErrorV3 in
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func fetchImage(from urlString: String) -> AnyPublisher<UIImage, BaseErrorV3> {
            apiManager.fetchImageData(from: urlString)
        }
    
}
