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
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
        return _description
        }
    }
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
    }
    }
    var defense: String {
        get {
        if _defense == nil {
        _defense = ""
        }
        return _defense
    }
    }
    var attack: String {
        get {
        if _attack == nil {
        _attack = ""
        }
        return _attack
    }
    }
    var height: String {
        get {
        if _height == nil {
        _height = ""
        }
        return _height
    }
    }
    var weight: String {
        get {
        if _weight == nil {
        _weight = ""
        }
        return _weight
    }
    }
    var nextEvolutionTxt: String {
        get {
        if _nextEvolutionTxt == nil {
        _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    }
    var nextEvolutionId: String {
        get {
        if _nextEvolutionId == nil {
        _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    }
    var nextEvolutionLvl: String {
        get {
        if _nextEvolutionLvl == nil {
        _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    }
    var pokemonUrl: String {
        get {
        if _pokemonUrl == nil {
        _pokemonUrl = ""
        }
        return _pokemonUrl
    }
    }
    var name: String {
        get {
            if _name == nil {
                _name = ""
            }
            return _name
        }
    }
    var pokedexId: Int {
        get {
            if _pokedexId == nil {
                _pokedexId = 0
            }
            return _pokedexId
        }
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
                if let descArr = dict["descriptions"] as?[Dictionary<String, String>] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                    }
                                }
                            completed()
                            }
                    }
                } else {
                    self._description = ""
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>]  where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil { //that means: word "mega" was not find in this String, can't support mega pokemon right now
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "") //this command is to replace "/api/.." to ""
                                // so, the uri number will be available to grab the pokemon next evolution number --> "resource_uri" : "/api/v1/pokemon/452/"
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "") // here is to remover the last slash, so we have only number now
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                                print(self._nextEvolutionLvl)
                                
                            }
                        }
                    }
                }
            }
        }
    }
}