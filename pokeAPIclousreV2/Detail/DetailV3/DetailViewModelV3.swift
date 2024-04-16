//
//  DetailViewModelV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 20/2/24.
//

import Foundation
import Combine
import UIKit

class DetailPokemonViewModelV3 {
    private var dataManager: DetailDataManagerV3
    private var cancellables = Set<AnyCancellable>()

    @Published var pokemonDetail: PokemonBusinessModel?
    @Published var errorMessage: String?
    @Published var pokemonImage: UIImage?
    @Published var evolutionImages: [String: UIImage] = [:]

    private var pokemonID: Int
    
    init(dataManager: DetailDataManagerV3, pokemonID: Int) {
        self.dataManager = dataManager
        self.pokemonID = pokemonID
        //loadPokemonDetailsAndEvolutions()
    }

    func loadPokemonDetailsAndEvolutions() {
        dataManager.fetchPokemonDetailsAndEvolutions(for: pokemonID)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { [weak self] pokemonModel in
                DispatchQueue.main.async {
                    self?.pokemonDetail = pokemonModel
                    self?.loadImage(for: pokemonModel.imageUrl)
                    self?.loadEvolutionImages(pokemonModel.evolutions)
                }
            })
            .store(in: &cancellables)
    }
    
    private func loadImage(for urlString: String) {
        dataManager.fetchImageData(from: urlString)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                DispatchQueue.main.async {
                    self?.pokemonImage = image
                }
            })
            .store(in: &cancellables)
    }

    private func loadEvolutionImages(_ evoluciones: [PokemonEvolution]) {
        evoluciones.forEach { evolution in
            dataManager.fetchImageData(from: evolution.imageUrl)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] image in
                    DispatchQueue.main.async {
                        self?.evolutionImages[evolution.name] = image
                    }
                })
                .store(in: &cancellables)
        }
    }
}
