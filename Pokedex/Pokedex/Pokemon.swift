//
//  Pokemon.swift
//  Pokedex
//
//  Created by Alberto Hirota on 8/13/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/" //injecting variables in the string
        
    }
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl)! //creating a url --> based on URL
        Alamofire.request(.GET, url).responseJSON { response in // it is creating another closure, after request run, it is saying to run this block of code
            let result = response.result //making the request
            print (result.value.debugDescription) //AlamoFire is to connect to server using JSON
            print (response.result)
            if let dict = result.value as? Dictionary<String, AnyObject> { //convert a JSON into a dictionary
                if let weight = dict["weight"] as? String {
                    self._weight = weight //if you have a property in the closure, you have always to use self object, refering where the object lives.
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>]  where types.count > 0 { //this as? -> means casting the dictionary, first convert
                    print(types.debugDescription) // if sucess convert it, then check if types is bigger than 0
                    if let name = types[0] ["name"] { //grab the first item, item number 0
                       // if let name = type ["name"] --> thats exactly same thing as ["name"] above
                       self._type = name.capitalizedString
                    }
                    if types.count > 1 {
                        for x in 1 ..< types.count {
                            if let name = types[x]["name"] {
                                    self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                print(self._type)
            }
        }
    }
}