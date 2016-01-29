//
//  Pokemon.swift
//  pokedex-by-ryanhuebert
//
//  Created by Ryan Huebert on 1/27/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    // Downloaded Data
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var name: String { return _name }
    var pokedexId: Int { return _pokedexId }
    var description: String? { return _description }
    var type: String? { return _type }
    var defense: String? { return _defense }
    var height: String? { return _height }
    var weight: String? { return _weight }
    var attack: String? { return _attack }
    var nextEvolutionTxt: String? { return _nextEvolutionTxt }
    var nextEvolutionId: String? { return _nextEvolutionId }
    var nextEvolutionLvl: String? { return _nextEvolutionLvl }
    
    // http://pokeapi.co/api/v1/pokemon/1/
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response -> Void in
            let result = response.result
            
            if let dict = result.value as? [String: AnyObject] {
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [[String: String]] where types.count > 0 {
                    var strings = [String]()
                    
                    for type in types {
                        if let string = type["name"] {
                            strings.append(string.capitalizedString)
                        }
                    }
                    
                    // Sort alphabetically
                    strings.sortInPlace({$0 < $1})
                    
                    // Join strings
                    self._type = strings.joinWithSeparator(", ")
                } else {
                    self._type = "No Type"
                }
                
                if let descArr = dict["descriptions"] as? [[String: String]] where descArr.count > 0 {
                    if let url = descArr[0]["resource_uri"] {
                        if let nsurl = NSURL(string: "\(URL_BASE)\(url)") {
                            Alamofire.request(.GET, nsurl).responseJSON(completionHandler: { (response) -> Void in
                                
                                let resourceResult = response.result
                                if let resourceDict = resourceResult.value as? [String: AnyObject] {
                                    if let desc = resourceDict["description"] as? String {
                                        self._description = desc
                                        print(self._description)
                                        
                                        
                                    }
                                }
                                
                                completed()
                            })
                        }
                        
                    }
                } else {
                    self._description = "No description."
                }
                
                // Evolutions
                
                if let evolutions = dict["evolutions"] as? [[String: AnyObject]] where evolutions.count > 0 {
                    
                    let evo = evolutions[0]
                    
                    if let to = evo["to"] as? String {
                        // Can't support mega pokemon
                        if to.rangeOfString("mega") == nil {
                            if let uri = evo["resource_uri"] as? String {
                                let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evo["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionLvl)
                                print(self._nextEvolutionTxt)
                            }
                        }
                    }
                    
                    
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                print(self._type)
                
                
                
            }
            
        }
        
    }
}