//
//  ListViewController.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import UIKit
import Combine

class ListViewController: UIViewController {

    @IBOutlet weak var tbList: UITableView!
    
    //APICLOUSURE
    //var viewModel: ListPokemonViewModel!
    //private var cancellables = Set<AnyCancellable>()
    
    //APICOMBINE
    var viewModel: PokemonListViewModelV3!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //APICLOUSURE
        /*
        tbList.register(UINib(nibName: "CellTableViewCell", bundle: nil), forCellReuseIdentifier: "CellTableViewCell")
        tbList.dataSource = self
        tbList.delegate = self
        showPokemos()
        viewModel.loadPokemons()
        */
        
        
        //APICOMBINE
        tbList.delegate = self
        tbList.dataSource = self
        tbList.register(UINib(nibName: "CellTableViewCell", bundle: nil), forCellReuseIdentifier: "CellTableViewCell")

        setupBindings()
        viewModel.fetchPokemonList()
    }
    //APICLOUSURE
    /*
    private func showPokemos() {
        viewModel.$pokemons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("Recargando datos de la tabla")
                self?.tbList.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { error in
                if let error = error {
                    print("Error: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    */
    //APICOMBINE
    private func setupBindings() {
        viewModel.$pokemonListItems
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tbList.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage, !errorMessage.isEmpty {
                    print("Error: \(errorMessage)")
                }
            }
            .store(in: &cancellables)
        
        viewModel.$imagesPokemon
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tbList.reloadData()
            }
            .store(in: &cancellables)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//APICLOUSURE
/*
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellTableViewCell", for: indexPath) as? CellTableViewCell else {
            return UITableViewCell()
        }
        let pokemonItem = viewModel.pokemons[indexPath.row]

        cell.lbNamePokemon.text = pokemonItem.name
        cell.imgePokemon.image = nil // eliminamaimagen previa para reutilización

        // trae la imagen
        viewModel.fetchImage(for: pokemonItem.imageUrl) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    if tableView.indexPath(for: cell) == indexPath {
                        cell.imgePokemon.image = image
                    }
                case .failure:
                    print("Error loading image")
                }
            }
        }

        return cell
    }
}




extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pokemonId = viewModel.pokemons[indexPath.row].id
        if let navigationController = navigationController {
            let wireframe = DetailWireframe()
            wireframe.push(from: navigationController, withPokemonId: pokemonId) 
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

*/

//APICOMBINE
extension ListViewController: UITableViewDataSource {
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
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pokemonId = viewModel.pokemonListItems[indexPath.row].id
        
        let wireframe = DetailWireframe()
        wireframe.push(from: navigationController, withPokemonId: pokemonId)
    }
}

