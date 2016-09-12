//
//  Pokecell.swift
//  Pokedex
//
//  Created by Patrick on 8/28/16.
//  Copyright © 2016 Little Lujan LLC. All rights reserved.
//

import UIKit

    
    class PokeCell: UICollectionViewCell {
        @IBOutlet weak var thumbImg: UIImageView!
        @IBOutlet weak var nameLbl: UILabel!
        
        var pokemon: Pokemon!
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            layer.cornerRadius = 5.0
        }
        
        func configureCell(pokemon: Pokemon) {
            self.pokemon = pokemon
            
            nameLbl.text = self.pokemon.name.capitalizedString
            thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
            
        }
    }


