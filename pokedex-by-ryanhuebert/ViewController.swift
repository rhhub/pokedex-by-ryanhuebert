//
//  ViewController.swift
//  pokedex-by-ryanhuebert
//
//  Created by Ryan Huebert on 1/27/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet private weak var collection: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var pokemon = [Pokemon]()
    private var collectionPokemon = [Pokemon]() {
        didSet {
            collection.reloadData()
        }
    }
    private var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = .Done
        parsePokemonCSV()
        collectionPokemon = pokemon
        //initAudio()
    }
    
    // MARK: Data Parsing
    
    private func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    // MARK: Collection View
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            let poke = collectionPokemon[indexPath.row]
            
            cell.configureCell(poke)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionPokemon.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        return CGSize(width: 105, height: 105)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke = collectionPokemon[indexPath.row]
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
//    // Seems to be what facebook uses but doesn't work if there isn't enough pokemon to scroll
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        view.endEditing(true)
//    }
    
    // Works immediately, pick your poisin.
    @IBAction func collectionViewGestureRecognizer(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // MARK: Audio
    
    @IBAction private func musicButtonPressed(sender: UIButton) {
        if let player = musicPlayer {
            if player.playing {
                player.stop()
                sender.alpha = 0.2
            } else {
                player.play()
                sender.alpha = 1.0
            }
        }
    }
    
    private func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // MARK: Search Bar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            collectionPokemon = pokemon
            view.endEditing(true)
        } else {
            let lower = searchBar.text!.lowercaseString
            collectionPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
        }
    }
}

