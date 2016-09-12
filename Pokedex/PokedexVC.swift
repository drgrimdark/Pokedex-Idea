//
//  PokedexVC.swift
//  Pokedex
//
//  Created by Patrick on 8/26/16.
//  Copyright © 2016 Little Lujan LLC. All rights reserved.
//

import UIKit

class PokedexVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
        
        @IBOutlet weak var collection: UICollectionView!
        @IBOutlet weak var searchBar: UISearchBar!
        
        var pokemon = [Pokemon]()
        var filteredPokemon = [Pokemon]()
        var inSearchMode = false
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            collection.delegate = self
            collection.dataSource = self
            searchBar.delegate = self
            searchBar.returnKeyType = UIReturnKeyType.Done
            parsePokemonCSV()
        }
        
        func parsePokemonCSV() {
            let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    let pokeId = Int(row["id"]!)!
                    let name = row["identifier"]
                    let poke = Pokemon(name: name!, pokedexId: pokeId)
                    pokemon.append(poke)
                    
                }
                
            } catch let err as NSError {
                print(err.debugDescription)
            }
            
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
                let poke: Pokemon!
                
                if inSearchMode {
                    poke = filteredPokemon[indexPath.row]
                } else {
                    poke = pokemon[indexPath.row]
                }
                
                cell.configureCell(poke)
                return cell
                
            } else {
                return UICollectionViewCell()
            }
            
        }
        
        
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            let poke: Pokemon!
            if inSearchMode{
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            performSegueWithIdentifier("PokemonDetailsVC", sender: poke)
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if inSearchMode{
                return filteredPokemon.count
            } else{
                
                return pokemon.count
            }
        }
        func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
            return 1
            
        }
        
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSizeMake(105, 105)
        }
        
        func searchBarSearchButtonClicked(searchBar: UISearchBar) {
            view.endEditing(true)
        }
        
        func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text == nil || searchBar.text == "" {
                inSearchMode = false
                view.endEditing(true)
                collection.reloadData()
            } else {
                inSearchMode = true
                let lower = searchBar.text!.lowercaseString
                
                filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
                collection.reloadData()
            }
        }
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "PokemonDetailsVC" {
                if let detailsVC = segue.destinationViewController as? PokemonDetailsVC {
                    if let poke = sender as? Pokemon {
                        detailsVC.pokemon = poke
                    }
                }
            }
        }
        
    }
    