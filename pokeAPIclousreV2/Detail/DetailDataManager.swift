//
//  DetailDataManager.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import Foundation
import UIKit



class DetailDataManager {
    private let apiManager = PokeApiManager()
    
    func fetchPokemonDetailsAndEvolutions(for id: Int, completion: @escaping (Result<PokemonBusinessModel, Error>) -> Void) {
        apiManager.fetchPokemonDetails(for: id) { [weak self] result in
            switch result {
            case .success(let detailResponse):
                self?.apiManager.fetchPokemonSpecies(for: id) { speciesResult in
                    switch speciesResult {
                    case .success(let speciesResponse):
                        self?.apiManager.fetchEvolutionChain(from: speciesResponse.evolutionChain.url) { evolutionResult in
                            DispatchQueue.main.async {
                                switch evolutionResult {
                                case .success(let evolutionChainResponse):
                                    let evolutions = self?.mapToEvolutions(evolutionChain: evolutionChainResponse) ?? []
                                    
                                    var businessModel = self?.mapToBusinessModel(detailResponse: detailResponse, evolutions: evolutions)
                                    completion(.success(businessModel!))
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    
    private func mapToEvolutions(evolutionChain: EvolutionChainResponse) -> [PokemonEvolution] {
        var evolutions: [PokemonEvolution] = []
        var currentLink: EvolutionLink? = evolutionChain.chain
        while let current = currentLink {
            let evolution = PokemonEvolution(name: current.species.name.capitalized, imageUrl: "")
            evolutions.append(evolution)
            currentLink = current.evolvesTo.first
        }
        return evolutions
    }


    private func mapToBusinessModel(detailResponse: PokemonDetailResponse, evolutions: [PokemonEvolution]) -> PokemonBusinessModel {
        let abilities = detailResponse.abilities.map { $0.ability.name.capitalized }
        return PokemonBusinessModel(
            id: detailResponse.id,
            name: detailResponse.name.capitalized,
            imageUrl: detailResponse.sprites.frontDefault,
            weight: detailResponse.weight,
            height: detailResponse.height,
            abilities: abilities,
            evolutions: evolutions
        )
    }

    
    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        apiManager.fetchImage(from: urlString, completion: completion)
    }
}
