//
//  PokeAgendaViewController.swift
//  PokemonGo
//
//  Created by 5A Nucleo Desenvolvimento on 19/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var pokemonsCapturados: [Pokemon] = []
    var pokemonsNaoCapturados: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let coreDataPokemon = CoreDataPokemon()
        
        self.pokemonsCapturados = coreDataPokemon.recuperarPokemons(capturado: true)
        self.pokemonsNaoCapturados = coreDataPokemon.recuperarPokemons(capturado: false)
    }

    @IBAction func voltarMapa(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        } else {
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonsCapturados.count
        } else {
            return pokemonsNaoCapturados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = self.pokemonsCapturados[indexPath.row]
        } else {
            pokemon = self.pokemonsNaoCapturados[indexPath.row]
        }
        
        let celula = UITableViewCell(style: .default, reuseIdentifier: "celula")
        
        celula.textLabel?.text = pokemon.nome
        celula.imageView?.image = UIImage(named: pokemon.nomeImagem!)
        
        return celula
    }
    
}
