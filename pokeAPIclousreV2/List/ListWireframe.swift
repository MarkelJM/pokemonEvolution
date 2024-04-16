//
//  ListWireframe.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import Foundation
import UIKit

class ListPokemonWireframe {
    
    var viewController: ListViewController {
        let viewController = ListViewController(nibName: "ListViewController", bundle: nil)
        
        let dataManager = createDataManagerV3()
        let viewModel = createViewModelV3(with: dataManager)
        
        viewController.viewModel = viewModel
        
        return viewController
    }

    private func createDataManagerV3() -> ListDataManagerV3 {
        return ListDataManagerV3()
    }

    private func createViewModelV3(with dataManager: ListDataManagerV3) -> PokemonListViewModelV3 {
        return PokemonListViewModelV3(dataManager: dataManager)
    }

}



/*
class ListPokemonWireframe {
    
    // Método para crear el MainListViewController
    var viewController: ListViewController {
        let viewController = ListViewController(nibName: "ListViewController", bundle: nil)
        let dataManager = createDataManager()
        let viewModel = createViewModel(with: dataManager)
        viewController.viewModel = viewModel
        return viewController
    }

    // Método privado para crear el ListDataManager
    private func createDataManager() -> ListDataManager {
        return ListDataManager()
    }

    // Método privado para crear el ListPokemonViewModel
    private func createViewModel(with dataManager: ListDataManager) -> ListPokemonViewModel {
        return ListPokemonViewModel(dataManager: dataManager)
    }

    // Método público para naveg
    /*
    func pushDetailViewController(navigation: UINavigationController?, pokemonUrl: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? DetailViewController {
            //detailViewController.pokemonUrl = pokemonUrl
            navigation?.pushViewController(detailViewController, animated: true)
        }
    }
     */

}
*/
