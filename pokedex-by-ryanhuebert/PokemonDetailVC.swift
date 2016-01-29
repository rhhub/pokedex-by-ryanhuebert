//
//  PokemonDetailVC.swift
//  pokedex-by-ryanhuebert
//
//  Created by Ryan Huebert on 1/28/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private weak var descriptionField: UITextView!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var defenseLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var attackLabel: UILabel!
    @IBOutlet private weak var evoLabel: UILabel!
    @IBOutlet private weak var currentEvoImage: UIImageView!
    
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLbl.text = pokemon.name.capitalizedString
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        
        
        
        pokemon.downloadPokemonDetails { () -> Void in
            // this will be called after download is done
            self.updateUI()
        }
    }
    
    private func updateUI() {
        descriptionField.text = pokemon.description ?? "" // when setting descriptionField.text to nil there is no crash, descriptionField.text is ! not sure what implications this has for setting, this is however a textField which must always return text as it can be editable
        typeLabel.text = pokemon.type
        defenseLabel.text = pokemon.defense
        weightLabel.text = pokemon.weight
        heightLabel.text = pokemon.height
        idLabel.text = "\(pokemon.pokedexId)"
        attackLabel.text = pokemon.attack
        
        if let id = pokemon.nextEvolutionId where id != "" {
            
            nextEvoImage.image = UIImage(named: id)
            nextEvoImage.hidden = false
            
            if let text = pokemon.nextEvolutionTxt {
                var str = "Next Evolution: \(text)"
                
                if let nextLvl = pokemon.nextEvolutionLvl where nextLvl != "" {
                    str += " - LVL \(nextLvl)"
                }
                evoLabel.text = str
            }

            
        } else {
            evoLabel.text = "No Evolutions"
            nextEvoImage.hidden = true
        }
        
            
            
        
        print(pokemon.description)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
