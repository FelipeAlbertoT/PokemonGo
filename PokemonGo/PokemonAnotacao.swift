//
//  PokemonAnotacao.swift
//  PokemonGo
//
//  Created by 5A Nucleo Desenvolvimento on 19/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import MapKit

class PokemonAnotacao: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    
    var pokemon: Pokemon
 
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
    
}
