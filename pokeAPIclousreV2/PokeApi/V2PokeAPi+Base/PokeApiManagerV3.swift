//
//  PokeApiManagerV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 19/2/24.
//

import Foundation
import Combine
import Alamofire
import UIKit

class PokeApiManagerV3: BaseAPIClientV3 {
 
    private let endpoint = "pokemon?limit=151"

    
    /*
    func fetchPokemonListCombine() -> AnyPublisher<[PokemonListItem], BaseErrorV3> {
        requestPublisher(relativePath: endpoint, method: .get, parameters: nil, urlEncoding: URLEncoding.default, type: PokemonListResponse.self)
            .map { response -> [PokemonListItem] in
                response.results
            }
            .mapError { error -> BaseErrorV3 in
                (error as? BaseErrorV3) ?? .generic
            }
            .eraseToAnyPublisher()
    }
     */
    
    func fetchPokemonListCombine() -> AnyPublisher<PokemonListResponse, BaseErrorV3> {
        return requestPublisher(relativePath: "pokemon?limit=151", method: .get, parameters: nil, urlEncoding: URLEncoding.default, type: PokemonListResponse.self)
    }
    
    func fetchPokemonDetails(for id: Int) -> AnyPublisher<PokemonDetailResponse, BaseErrorV3> {
        return requestPublisher(relativePath: "pokemon/\(id)", method: .get, type: PokemonDetailResponse.self)
    }
    
    func fetchPokemonSpecies(for id: Int) -> AnyPublisher<PokemonSpeciesResponse, BaseErrorV3> {
        return requestPublisher(relativePath: "pokemon-species/\(id)", method: .get, type: PokemonSpeciesResponse.self)
    }
    
    func fetchEvolutionChain(from urlString: String) -> AnyPublisher<EvolutionChainResponse, BaseErrorV3> {
        guard let url = URL(string: urlString), let relativePath = url.relativePath.removingPercentEncoding else {
            return Fail(error: BaseErrorV3.generic).eraseToAnyPublisher()
        }
        
        let cleanedPath = relativePath.replacingOccurrences(of: "/api/v2/", with: "")
        return requestPublisher(relativePath: cleanedPath, method: .get, type: EvolutionChainResponse.self)
    }
    
    func fetchImageData(from urlString: String) -> AnyPublisher<UIImage, BaseErrorV3> {
        
        
        guard let url = URL(string: urlString) else {
            return Fail(error: BaseErrorV3.generic).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> UIImage in
                guard let image = UIImage(data: result.data) else {
                    throw BaseErrorV3.generic
                }
                return image
            }
            .mapError { _ in BaseErrorV3.generic }
            .eraseToAnyPublisher()
    }
}
