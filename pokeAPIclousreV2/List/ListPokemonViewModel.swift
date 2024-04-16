//
//  ListPokemonViewModel.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import Foundation
import UIKit
import Combine

class ListPokemonViewModel {
    @Published var pokemons: [PokemonBusinessModel] = []
    @Published var errorMessage: String?
    
    private var dataManager: ListDataManager
    
    init(dataManager: ListDataManager) {
        self.dataManager = dataManager
    }
    
    func loadPokemons() {
        dataManager.fetchPokemonList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let pokemonBusinessModels):
                    self?.pokemons = pokemonBusinessModels
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchImage(for urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        dataManager.fetchImage(from: urlString, completion: completion)
    }

}
