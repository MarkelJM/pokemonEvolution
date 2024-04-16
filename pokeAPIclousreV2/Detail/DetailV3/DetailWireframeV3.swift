//
//  DetailWireframeV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 21/2/24.
//

import Foundation
import UIKit

class DetailWireframeV3 {
    
    func push(from navigation: UINavigationController?, withPokemonId pokemonId: Int) {
        let viewController = createViewController(withPokemonId: pokemonId)
        guard let navigation = navigation else {
            fatalError("NavigationController is nil")
        }
        navigation.pushViewController(viewController, animated: true)
    }
    
    private func createViewController(withPokemonId pokemonId: Int) -> DetailV2ViewController {
        let viewController = DetailV2ViewController(nibName: "DetailV2ViewController", bundle: nil)
        let dataManager = DetailDataManagerV3() // Usando la versión V3 del DataManager
        let viewModel = DetailPokemonViewModelV3(dataManager: dataManager, pokemonID: pokemonId)
        viewController.viewModel = viewModel
        return viewController
    }
}
