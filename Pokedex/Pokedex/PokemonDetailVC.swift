//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon! //this is required, to receive information from other view Controller, it will happen BEFORE ViewDidLoad happens and data will be already available
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
