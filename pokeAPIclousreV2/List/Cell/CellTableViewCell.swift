//
//  CellTableViewCell.swift
//  pokeAPIclousreV2
//
//  Created by Markel Juaristi Mendarozketa   on 12/2/24.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var lbNamePokemon: UILabel!
    @IBOutlet weak var imgePokemon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
