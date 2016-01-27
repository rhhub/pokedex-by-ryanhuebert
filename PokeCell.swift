//
//  PokeCell.swift
//  pokedex-by-ryanhuebert
//
//  Created by Ryan Huebert on 1/27/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet private weak var thumbImg: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
}
