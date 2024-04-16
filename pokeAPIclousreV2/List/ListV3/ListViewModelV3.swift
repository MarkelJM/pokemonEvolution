//
//  ListViewModelV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 19/2/24.
//

import Foundation
import Combine
import UIKit

class PokemonListViewModelV3 {
    private var dataManager: ListDataManagerV3
    private var cancellables = Set<AnyCancellable>()

    @Published var pokemonListItems: [PokemonBusinessModel] = []
    @Published var errorMessage: String?
    @Published var imagesPokemon: [String: UIImage] = [:]

    init(dataManager: ListDataManagerV3) {
        self.dataManager = dataManager
    }

    func fetchPokemonList() {
        dataManager.fetchPokemonList()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Carga completada.")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error al cargar los datos: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] pokemonList in
                print("Datos recibidos: \(pokemonList)")
                self?.pokemonListItems = pokemonList
            })
            .store(in: &cancellables)
    }


    func fetchImage(for urlString: String) {
        guard imagesPokemon[urlString] == nil else { return }
        
        dataManager.fetchImage(from: urlString)
            .map { $0 }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching image: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] image in
                self?.imagesPokemon[urlString] = image
            })
            .store(in: &cancellables)
    }
}
