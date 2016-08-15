//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var pokedexIdLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evolution1Img: UIImageView!
    @IBOutlet weak var evolution2Img: UIImageView!
    @IBOutlet weak var evolutionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        evolution1Img.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            print("DID WE GET HERE")
            self.updateUI()
        }
    }
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        baseAttackLbl.text = pokemon.attack
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        nameLbl.text = pokemon.name.capitalizedString
        pokedexIdLbl.text = "\(pokemon.pokedexId)"
        
        if pokemon.nextEvolutionId == "" {
            evolutionLbl.text = "No Evolutions"
            evolution2Img.hidden = true
        } else {
                evolution2Img.hidden = false
            evolution2Img.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            if pokemon.nextEvolutionLvl != "" {
                str += " = LVL \(pokemon.nextEvolutionLvl)"
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
