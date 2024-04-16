//
//  ListControllerTemporalV3.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 20/2/24.
//
/*
import Foundation
import UIKit
import Combine

class ListViewControllerV3: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PokemonListViewModelV3!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        viewModel.fetchPokemonList()
    }
    
    private func setupBindings() {
        // Binding para la lista de pokemons
        viewModel.$pokemonListItems
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Binding para los errores
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage, !errorMessage.isEmpty {
                    // Aquí puedes manejar el error, como mostrar un alerta
                    print("Error: \(errorMessage)")
                }
            }
            .store(in: &cancellables)
        
        // Binding para las imágenes
        viewModel.$imagesPokemon
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension ListViewControllerV3: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonListItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableViewCell", for: indexPath) as? CellTableViewCell else {
            return UITableViewCell()
        }
        let pokemonItem = viewModel.pokemonListItems[indexPath.row]

        cell.lbNamePokemon.text = pokemonItem.name
        cell.imgePokemon.image = viewModel.imagesPokemon[pokemonItem.imageUrl] // Usa la imagen si ya está cargada
        
        // Si no hay imagen cargada, intenta buscarla
        if cell.imgePokemon.image == nil {
            viewModel.fetchImage(for: pokemonItem.imageUrl)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewControllerV3: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Ajusta según el diseño de tu celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Maneja la selección de un elemento, por ejemplo, navegando a una vista detallada
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
*/
