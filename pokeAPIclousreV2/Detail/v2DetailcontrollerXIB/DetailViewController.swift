//
//  DetailViewController.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import UIKit
import Combine

class DetailViewController: UIViewController {

    @IBOutlet weak var lbNameDetail: UILabel!
    
    @IBOutlet weak var imgPokemonDetail: UIImageView!
    
    @IBOutlet weak var lbWeight: UILabel!
    
    @IBOutlet weak var lbHeight: UILabel!
    
    @IBOutlet weak var listAbilities: UITableView!
    
    var viewModel : DetailPokemonViewModel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listAbilities.register(UINib(nibName: "AbilityCell", bundle: nil), forCellReuseIdentifier: "AbilityCell")

        setupUI()
        
        listAbilities.dataSource = self
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setupUI() {
        guard let pokemonDetail = viewModel.pokemonDetail else {
            print("Error en el setupUI")
            return
        }
        
        lbNameDetail.text = pokemonDetail.name
        lbWeight.text = "Weight: \(pokemonDetail.weight)"
        lbHeight.text = "Height: \(pokemonDetail.height)"
        imgPokemonDetail.image = viewModel.pokemonImage
        listAbilities.reloadData()
    }



}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonDetail?.abilities.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AbilityCell", for: indexPath) as? AbilityCell,
              let ability = viewModel.pokemonDetail?.abilities[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = ability
        return cell
    }
}


    


