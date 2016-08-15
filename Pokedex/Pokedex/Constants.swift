//
//  Constants.swift
//  Pokedex
//
//  Created by Alberto Hirota on 8/15/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import Foundation

// if we don't put classes, it will be globally accessible

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

typealias DownloadComplete = () -> () //we are creating a closure, a block of code that will be called whenever we want to
// first () means, we are not passing anything. And second one, it means we are not return anything.
