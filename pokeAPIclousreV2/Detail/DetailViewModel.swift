//
//  DetailViewModel.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import Foundation
import UIKit
import Combine

class DetailPokemonViewModel {
    private let dataManager: DetailDataManager
    private var pokemonID: Int
    
    var evolutionImages: [String: UIImage] = [:]
    var onDetailsLoaded: (() -> Void)?
    var onImageLoaded: (() -> Void)?
    var onEvolutionsImagesUpdated: ((IndexPath) -> Void)?
    
    @Published var pokemonDetail: PokemonBusinessModel?
    @Published var errorMessage: String?
    @Published var pokemonImage: UIImage?
    
    init(dataManager: DetailDataManager, pokemonID: Int) {
        self.dataManager = dataManager
        self.pokemonID = pokemonID
        loadPokemonDetailsAndEvolutions()
    }
    
    func loadPokemonDetailsAndEvolutions() {
        dataManager.fetchPokemonDetailsAndEvolutions(for: pokemonID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let businessModel):
                    self?.pokemonDetail = businessModel
                    self?.loadPokemonImage(imageURL: businessModel.imageUrl)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    /*
    func loadPokemonImage(imageURL: String, completion: @escaping (UIImage?) -> Void) {
        dataManager.fetchImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }
    */
    func loadPokemonImage(imageURL: String) {
        dataManager.fetchImage(from: imageURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.pokemonImage = image
                    self?.onImageLoaded?()
                case .failure:
                    self?.pokemonImage = nil
                }
            }
        }
    }
    func loadEvolutionsImages() {
        guard let evolutions = pokemonDetail?.evolutions else { return }
        
        for evolution in evolutions {
            dataManager.fetchImage(from: evolution.imageUrl) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        print("Imagen de evolución cargada exitosamente para \(evolution.name)")
                        self?.evolutionImages[evolution.name] = image
                        if let index = self?.pokemonDetail?.evolutions.firstIndex(where: { $0.name == evolution.name }) {
                            let indexPath = IndexPath(row: index, section: 0)
                            
                            self?.onEvolutionsImagesUpdated?(indexPath)
                        }
                    case .failure:
                        print("Error al cargar la imagen de evolución para \(evolution.name)")
                    }
                }
            }
        }
    }

   
    
    
    var weightInKilograms: Double {
        return Double(pokemonDetail?.weight ?? 0) / 10.0
    }
    
    var weightInPounds: Double {
        return weightInKilograms * 2.20462
    }
    
    var weightInOunces: Double {
        return weightInKilograms * 35.274
    }
    
    var heightInMeters: Double {
        return Double(pokemonDetail?.height ?? 0) / 10.0
    }
    
    var heightInFeet: Double {
        return heightInMeters * 3.28084
    }


}





