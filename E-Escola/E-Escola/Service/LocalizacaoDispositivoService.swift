//
//  LocalizacaoDispositivoService.swift
//  E-Escola
//
//  Created by Fábio Sales on 31/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol LocalizacaoDispositivo: class {
    @objc optional func localizacaAtual(localizacaoAtual localizacaoDispositivo:CLLocation,_ error:Error?)
}

class LocalizacaoDispositivoService: NSObject {
    
    private var erro:Error?
    public weak var delegate:LocalizacaoDispositivo?
    
    private var localizacao: CLLocation?{
        didSet{
            if let locTemp = localizacao {
                let coordOld = oldValue?.coordinate
                let coord = locTemp.coordinate
                if coordOld?.longitude != coord.longitude
                    || coordOld?.latitude != coord.latitude{
                    delegate?.localizacaAtual!(localizacaoAtual: locTemp, erro)
                }
            }
            
        }
    }
    
    
    private static var instacia: LocalizacaoDispositivoService = {
        let instaciaTemp = LocalizacaoDispositivoService()
        return instaciaTemp
    }()
    
    private lazy var  gerenciadorLocalizacao: CLLocationManager =  { [weak self] in
        let loc: CLLocationManager = CLLocationManager()
        
        // solicitar permissao
        loc.requestAlwaysAuthorization()
        // configura o delegate
        loc.delegate = self
        
        // distancia de 100 metros
        //loc.distanceFilter = 100.00
        
        // configurar precisao
        loc.desiredAccuracy = kCLLocationAccuracyBest
        loc.distanceFilter = kCLLocationAccuracyHundredMeters
        loc.activityType = .otherNavigation
        return loc
    }()
    
    private override init() {
        super.init()
        verificaAutorizacaoUsuario()
        iniciaAtualizarLocalizacao()
    }
    
    class func shared() -> LocalizacaoDispositivoService {
        return instacia
    }
    
    private func verificaAutorizacaoUsuario(){
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
       
    }
    
    public func iniciaAtualizarLocalizacao(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            gerenciadorLocalizacao.startUpdatingLocation()
            gerenciadorLocalizacao.requestLocation()
            
        }
    }
    
    public func location(){
        if let locTemp = gerenciadorLocalizacao.location{
            delegate?.localizacaAtual!(localizacaoAtual: locTemp, erro)
            localizacao = locTemp
        }
    }
    
    private func terminarAtualizarLocalizacao(){
        self.gerenciadorLocalizacao.stopUpdatingLocation()
    }
    
    private func alertPermissaoLocalizacao(){
        let alertaController = UIAlertController(title: "Permissão de localização",
                                                 message: "Necessário permissão para acesso à sua localização!! por favor habilite.",
                                                 preferredStyle: .alert )
        
        let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default , handler: { (alertaConfiguracoes) in
            
            if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString ) {
                UIApplication.shared.open( configuracoes as URL )
            }
            
        })
        
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default , handler: nil )
        
        alertaController.addAction( acaoConfiguracoes )
        alertaController.addAction( acaoCancelar )
    }
}

extension LocalizacaoDispositivoService: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted, .denied:
            terminarAtualizarLocalizacao()
            alertPermissaoLocalizacao()
            break
            
        case .authorizedWhenInUse:
            verificaAutorizacaoUsuario()
            iniciaAtualizarLocalizacao()
            break
            
        case .authorizedAlways:
            verificaAutorizacaoUsuario()
            iniciaAtualizarLocalizacao()
            break
            
        case .notDetermined:
            terminarAtualizarLocalizacao()
            alertPermissaoLocalizacao()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        localizacao = locations.last!
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.localizacao = manager.location!
        self.erro = error
    }
}

