//
//  DetailDataManagerV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 20/2/24.
//


import Foundation
import Combine
import UIKit

class DetailDataManagerV3 {
    private var apiManager = PokeApiManagerV3()
    
    // Función para obtener los detalles del Pokémon y sus evoluciones
    func fetchPokemonDetailsAndEvolutions(for id: Int) -> AnyPublisher<PokemonBusinessModel, BaseErrorV3> {
        apiManager.fetchPokemonDetails(for: id)
            .flatMap { details -> AnyPublisher<(PokemonDetailResponse, PokemonSpeciesResponse), BaseErrorV3> in
                self.apiManager.fetchPokemonSpecies(for: id)
                    .map { species -> (PokemonDetailResponse, PokemonSpeciesResponse) in
                        (details, species)
                    }
                    .eraseToAnyPublisher()
            }
            .flatMap { details, species -> AnyPublisher<(PokemonDetailResponse, PokemonSpeciesResponse, EvolutionChainResponse), BaseErrorV3> in
                self.apiManager.fetchEvolutionChain(from: species.evolutionChain.url)
                    .map { evolutionChain -> (PokemonDetailResponse, PokemonSpeciesResponse, EvolutionChainResponse) in
                        (details, species, evolutionChain)
                    }
                    .eraseToAnyPublisher()
            }
            .map { details, species, evolutionChain in
                self.mapToBusinessModel(detailResponse: details, speciesResponse: species, evolutionChain: evolutionChain)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchImageData(from urlString: String) -> AnyPublisher<UIImage, BaseErrorV3> {
        return apiManager.fetchImageData(from: urlString)
    }
    
    private func mapToBusinessModel(detailResponse: PokemonDetailResponse, speciesResponse: PokemonSpeciesResponse, evolutionChain: EvolutionChainResponse) -> PokemonBusinessModel {
        let abilities = detailResponse.abilities.map { $0.ability.name.capitalized }
        let evolutions = mapEvolutions(chain: evolutionChain.chain)
        
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

    private func mapEvolutions(chain: EvolutionLink?) -> [PokemonEvolution] {
        var evolutions: [PokemonEvolution] = []
        var currentLink = chain
        
        while let current = currentLink {
            let pokemonId = current.species.url.split(separator: "/").last.flatMap { Int($0) }
            let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonId ?? 0).png"
            
            let evolution = PokemonEvolution(name: current.species.name.capitalized, imageUrl: imageUrl)
            evolutions.append(evolution)
            
            currentLink = current.evolvesTo.first
        }
        
        return evolutions
    }
}
