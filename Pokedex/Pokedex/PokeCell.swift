//
//  PokeCell.swift
//  Pokedex
//
//  Created by Alberto Hirota on 8/13/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    var pokemon: Pokemon!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func configureCell (_ pokemon: Pokemon){
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
