//
//  ViewController.swift
//  PokemonGo
//
//  Created by 5A Nucleo Desenvolvimento on 16/03/2018.
//  Copyright © 2018 Felipe Alberto Treichel. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    let gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recuperarTodosPokemons()
        
        //Exibir pokemons
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { (timer) in
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                let indicePokemonAleatorio = arc4random_uniform(UInt32(self.pokemons.count))
                
                let pokemon = self.pokemons[Int(indicePokemonAleatorio)]
                
                let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon)
                anotacao.coordinate.latitude += (Double(arc4random_uniform(400)) - 200) / 100000.0
                anotacao.coordinate.longitude += (Double(arc4random_uniform(400)) - 200) / 100000.0
                
                
                self.mapa.addAnnotation(anotacao)
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            anotacaoView.image = #imageLiteral(resourceName: "player")
        } else {
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            
            anotacaoView.image = UIImage(named: pokemon.nomeImagem!)
        }
        
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let anotacao = view.annotation
        mapView.deselectAnnotation(anotacao, animated: true)
        
        if anotacao is MKUserLocation {
            return
        }
        
        let pokemon = (view.annotation as! PokemonAnotacao).pokemon

        if let coordenada = view.annotation?.coordinate {
            let regiao = MKCoordinateRegionMakeWithDistance(coordenada, 200, 200)
            mapa.setRegion(regiao, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coordenadasUsuario = self.gerenciadorLocalizacao.location?.coordinate {
                if MKMapRectContainsPoint(self.mapa.visibleMapRect, MKMapPointForCoordinate(coordenadasUsuario)) {
                    self.coreDataPokemon.capturar(pokemon)
                    
                    mapView.removeAnnotation(anotacao!)
                    
                    let alertController = UIAlertController(title: "Pokemon capturado", message: "Você capturou o pokemon: \(pokemon.nome!)", preferredStyle: .alert)
                    let acaoOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(acaoOk)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Você não pode capturar", message: "Você precisa se aproximar mais para capturar o pokemon: \(pokemon.nome!)", preferredStyle: .alert)
                    let acaoOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(acaoOk)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador < 5 {
            self.centralizar()
            contador += 1
        } else {
            gerenciadorLocalizacao.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            let alertController = UIAlertController(title: "Permissão de localização", message: "Para que você possa caçar Pokemons, precisamos da sua localização! Por favor, habilite.", preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alertController.addAction(acaoConfiguracoes)
            alertController.addAction(acaoCancelar)
            
            present(alertController, animated: true, completion: nil)
            
        }
    }

    func centralizar() {
        if let coordenada = gerenciadorLocalizacao.location?.coordinate {
            let regiao = MKCoordinateRegionMakeWithDistance(coordenada, 200, 200)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
    @IBAction func centralizarJogador(_ sender: Any) {
        self.centralizar()
    }
    
    @IBAction func abrirPokedex(_ sender: Any) {
        
    }
}

