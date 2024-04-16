//
//  DetailV2ViewController.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 13/2/24.
//

import UIKit
import Combine

class DetailV2ViewController: UIViewController {

    @IBOutlet weak var listEvolutions: UITableView!
    @IBOutlet weak var listAbilities: UITableView!
    @IBOutlet weak var lbHeightPies: UILabel!
    @IBOutlet weak var lbHeightM: UILabel!
    @IBOutlet weak var lbWeightOz: UILabel!
    @IBOutlet weak var lbWeightLb: UILabel!
    @IBOutlet weak var lbWeightKG: UILabel!
    @IBOutlet weak var imgPhotoDetail: UIImageView!
    @IBOutlet weak var lbNameDetail: UILabel!
    
    //APICLOUSURE
    //var viewModel : DetailPokemonViewModel!
    //APICOMBINE
    var viewModel : DetailPokemonViewModelV3!

    private var cancellables: Set<AnyCancellable> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Si tardan en llegar los datos:
        lbNameDetail.text = "Cargando..."
        lbWeightKG.text = "Cargando..."
        lbWeightLb.text = "Cargando..."
        lbWeightOz.text = "Cargando..."
        lbHeightM.text = "Cargando..."
        lbHeightPies.text = "Cargando..."
        imgPhotoDetail.image = UIImage(named: "placeholderImage")
        
        //APICLOUSURE
        /*
         setupTableView()
         setupViewModel()
         viewModel.loadPokemonDetailsAndEvolutions()
         
         viewModel.onEvolutionsImagesUpdated = { [weak self] indexPath in
             self?.listEvolutions.reloadRows(at: [indexPath], with: .fade)
         }
         viewModel.$pokemonDetail
             .compactMap { $0 }
             .receive(on: DispatchQueue.main) // Actualiza en el hilo principal
             .sink { [weak self] pokemonDetail in
                 print("Detalle del Pokémon recibido: \(pokemonDetail)")
                 self?.updateUI()
                 self?.listEvolutions.reloadData()
             }
             .store(in: &cancellables)
         
         // rebisa cambios en la imagen del Pokémon
         viewModel.$pokemonImage
             .compactMap { $0 }
             .receive(on: DispatchQueue.main)
             .sink { [weak self] image in
                 print("Imagen del Pokémon recibida.")
                 self?.imgPhotoDetail.image = image
             }
             .store(in: &cancellables)
         
         
         */
        
        //APICOMBINE
        setupTableView()
        setupBindings()
        
        viewModel.loadPokemonDetailsAndEvolutions()
        
        
        

        
        
        
        
        
    }
    //APICLOUSURE
    /*
    private func setupViewModel() {
        viewModel.onDetailsLoaded = { [weak self] in
            self?.updateUI()
        }
        
        viewModel.onImageLoaded = { [weak self] in
            self?.imgPhotoDetail.image = self?.viewModel.pokemonImage
        }
    }
    
    private func setupTableView() {
        listAbilities.dataSource = self
        listAbilities.register(UITableViewCell.self, forCellReuseIdentifier: "AbilityCell")
        
        listEvolutions.dataSource = self
        listEvolutions.delegate = self
        listEvolutions.register(UINib(nibName: "EvolutionsTableViewCell", bundle: nil), forCellReuseIdentifier: "EvolutionCell")
    }

    private func updateUI() {
        guard let pokemonDetail = viewModel.pokemonDetail else {return}
        lbNameDetail.text = pokemonDetail.name
        lbWeightKG.text = String(format: "%.2f kg", viewModel.weightInKilograms)
        lbWeightLb.text = String(format: "%.2f lb", viewModel.weightInPounds)
        lbWeightOz.text = String(format: "%.2f oz", viewModel.weightInOunces)
        lbHeightM.text = String(format: "%.2f m", viewModel.heightInMeters)
        lbHeightPies.text = String(format: "%.2f ft", viewModel.heightInFeet)
        
        imgPhotoDetail.image = viewModel.pokemonImage
        listAbilities.reloadData()
        listEvolutions.reloadData()
    }
     */
    //APICOMBINE
    private func setupBindings() {
        viewModel.$pokemonDetail
            .compactMap { $0 }
            .receive(on: DispatchQueue.main) 
            .sink { [weak self] pokemonDetail in
                print("Detalle del Pokémon recibido: \(pokemonDetail)")
                self?.updateUI(with: pokemonDetail)
                self?.listEvolutions.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$pokemonImage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                print("Imagen del Pokémon recibida.")
                self?.imgPhotoDetail.image = image
            }
            .store(in: &cancellables)
        
    }
    
    private func setupTableView() {
        listAbilities.dataSource = self
        listAbilities.register(UITableViewCell.self, forCellReuseIdentifier: "AbilityCell")
        
        listEvolutions.dataSource = self
        listEvolutions.delegate = self
        listEvolutions.register(UINib(nibName: "EvolutionsTableViewCell", bundle: nil), forCellReuseIdentifier: "EvolutionCell")
    }

    private func updateUI(with pokemonDetail: PokemonBusinessModel) {
        lbNameDetail.text = pokemonDetail.name
        lbWeightKG.text = String(format: "%.2f kg", Double(pokemonDetail.weight) / 10.0)
        lbWeightLb.text = String(format: "%.2f lb", Double(pokemonDetail.weight) / 10.0 * 2.20462)
        lbWeightOz.text = String(format: "%.2f oz", Double(pokemonDetail.weight) / 10.0 * 35.274)
        lbHeightM.text = String(format: "%.2f m", Double(pokemonDetail.height) / 10.0)
        lbHeightPies.text = String(format: "%.2f ft", Double(pokemonDetail.height) / 10.0 * 3.28084)
        
        listAbilities.reloadData()
        listEvolutions.reloadData()
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
extension DetailV2ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == listAbilities {
            return viewModel?.pokemonDetail?.abilities.count ?? 0
        } else if tableView == listEvolutions {
            return viewModel?.pokemonDetail?.evolutions.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == listAbilities {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AbilityCell", for: indexPath)
            if let ability = viewModel?.pokemonDetail?.abilities[indexPath.row] {
                cell.textLabel?.text = ability
            }
            return cell
        }
        if tableView == listEvolutions {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EvolutionCell", for: indexPath) as? EvolutionsTableViewCell,
                  let evolution = viewModel?.pokemonDetail?.evolutions[indexPath.row] else {
                return UITableViewCell()
            }
            
            cell.lbEvolutionName.text = evolution.name
            
            if evolution.name.lowercased() == viewModel.pokemonDetail?.name.lowercased() {
                        cell.backgroundColor = UIColor.yellow
                    } else {
                        cell.backgroundColor = UIColor.clear
                    }
            
            return cell
        }
        return UITableViewCell()
    }
}

extension DetailV2ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
}
 */

//APICOMBINE

//APICOMBINE
extension DetailV2ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == listAbilities {
            return viewModel.pokemonDetail?.abilities.count ?? 0
        } else if tableView == listEvolutions {
            return viewModel.pokemonDetail?.evolutions.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == listAbilities {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AbilityCell", for: indexPath)
            cell.textLabel?.text = viewModel.pokemonDetail?.abilities[indexPath.row]
            return cell
        } else if tableView == listEvolutions {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EvolutionCell", for: indexPath) as? EvolutionsTableViewCell,
                  let evolution = viewModel.pokemonDetail?.evolutions[indexPath.row] else {
                return UITableViewCell()
            }
            cell.lbEvolutionName.text = evolution.name
            
            return cell
        }
        return UITableViewCell()
    }
}

extension DetailV2ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

