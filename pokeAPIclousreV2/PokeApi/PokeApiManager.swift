//
//  PokeApiManager.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import Foundation
import Alamofire
import UIKit

class PokeApiManager: BaseAPIClient {
    private let baseURL = "https://pokeapi.co/api/v2/"

    func fetchPokemonList(completion: @escaping (Result<[PokemonListItem], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon?limit=151") else {
            completion(.failure(BaseError.customError("Invalid URL")))
            return
        }
        
        request(url, method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let listResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                    completion(.success(listResponse.results))
                } catch {
                    completion(.failure(BaseError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchPokemonDetails(for id: Int, completion: @escaping (Result<PokemonDetailResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon/\(id)") else {
            completion(.failure(BaseError.customError("Invalid URL")))
            return
        }
        
        request(url, method: .get) { result in
            switch result {
            case .success(let data):
                //print(String(data: data, encoding: .utf8) ?? "No raw data")
                do {
                    let detailResponse = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
                    completion(.success(detailResponse))
                } catch {
                    print(error)
                    completion(.failure(BaseError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(BaseError.customError("Invalid URL")))
            return
        }
        
        request(url, method: .get) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(BaseError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    ///EVOLVES
    // Obtener la especie del Pokémon por ID, devuel url de la cadena de evolucions
    func fetchPokemonSpecies(for id: Int, completion: @escaping (Result<PokemonSpeciesResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon-species/\(id)") else {
            completion(.failure(BaseError.customError("Invalid URL")))
            return
        }
        
        request(url, method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let speciesResponse = try JSONDecoder().decode(PokemonSpeciesResponse.self, from: data)
                    completion(.success(speciesResponse))
                } catch {
                    completion(.failure(BaseError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    //obtiene la s evolucion
    func fetchEvolutionChain(from url: String, completion: @escaping (Result<EvolutionChainResponse, Error>) -> Void) {
        guard let evolutionChainURL = URL(string: url) else {
            completion(.failure(BaseError.customError("Invalid URL")))
            return
        }
        
        request(evolutionChainURL, method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let evolutionChainResponse = try JSONDecoder().decode(EvolutionChainResponse.self, from: data)
                    completion(.success(evolutionChainResponse))
                } catch {
                    completion(.failure(BaseError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}




