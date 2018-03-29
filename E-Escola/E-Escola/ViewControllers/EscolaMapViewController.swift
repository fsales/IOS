//
//  EscolaMapViewController.swift
//  E-Escola
//
//  Created by Fábio Sales on 31/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import MapKit

class EscolaMapViewController: UIViewController {

    private var localizacao:LocalizacaoDispositivoService?
    private var escola: EscolaService = EscolaService.shared()
    
    @IBOutlet weak var mapa: MKMapView?{
        didSet{
            self.mapa?.mapType = MKMapType.hybrid
        }
    }
    private var localizacaoAtual: CLLocation?
    
    private lazy var persistentContainer = { [weak self] in
        return AppDelegate.persistentContainer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).sync {
            self.mapa?.delegate = self
            self.localizacao = LocalizacaoDispositivoService.shared()
            self.localizacao?.delegate = self
            self.escola.delegate = self
        }
        
         NotificationCenter.default.addObserver(self, selector: #selector(onEscalasCoreData(_:)), name: Notification.Name.EscolaFetched, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func onEscalasCoreData(_ notification: Notification) {
        if let esc = notification.userInfo?[EscolaService.CHAVE_USER_INFO] as? [Escola]{
            marcarEscolasMapa(esc)
        }
    }
    
    func marcarEscolasMapa(_ escolas: [Escola]?){
        
        if(escolas == nil){
            ProgressView.hide()
        }
        
        marcarLocalizacaoAtual()
        var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
         DispatchQueue.global(qos: .background).sync {
            if let escolaTemp = escolas {
                
                for escola in escolaTemp{
                    if let geolocalizacao = escola.geo{
                        let pin:MKPointAnnotation = MKPointAnnotation()
                        pin.coordinate = geolocalizacao.asLocationCoordinate()
                        pin.title = escola.nome
                        if let email = escola.email, let  endereco = escola.endereco?.enderecoFormatado(){
                            pin.subtitle = "Email: \(email)\nEndereco: \(endereco) "
                        }
                        annotations.append(pin)
                    }
                }
                addAnnotationsMap(annotations)
                ProgressView.hide()
            }
        }
        
        
    }
    
    func addAnnotationsMap(_ annotations: [MKPointAnnotation]){
        DispatchQueue.main.async {
            self.mapa?.addAnnotations(annotations)
        }
    }
    
    func marcarLocalizacaoAtual(){
        if let loc = localizacaoAtual {
            exibirLocal(loc.coordinate)
        } else {
            ProgressView.hide()
        }
    }
    
    func exibirLocal(_ cordenadas: CLLocationCoordinate2D){
        let span = MKCoordinateSpanMake(0.09, 0.09)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(cordenadas, span)
        self.mapa?.setRegion(regiao, animated: true)
       
    }
    
    func marcacao(_ cordenadas: CLLocationCoordinate2D){
        let anotacao = MKPointAnnotation()
        anotacao.coordinate.latitude = cordenadas.latitude
        anotacao.coordinate.longitude = cordenadas.longitude
        self.mapa?.addAnnotation(anotacao)
    }
  
}

extension EscolaMapViewController: LocalizacaoDispositivo, EscolaDelegate{
    func resultadoEscolaCoreData(_ escolas: [Escola]?, error: Error?) {
        
        if let err = error{
            ProgressView.hide()
            self.genericErrorAlert(err)
            return
        }
        
        marcarEscolasMapa(escolas)
    }
    
    func localizacaAtual(localizacaoAtual localizacaoDispositivo: CLLocation, _ error: Error?) {
        
        if let err = error{
            ProgressView.hide()
            self.genericErrorAlert(err)
            return
        }
        ProgressView.show()
        marcarLocalizacaoAtual()
        print(localizacaoDispositivo)
        self.escola.buscarEscolas(localizacaoDispositivo.coordinate)
    }
}

extension EscolaMapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
        pinView.tintColor = UIColor.red
        pinView.canShowCallout = true
        
        let btPin = UIButton(type: UIButtonType.detailDisclosure) as UIView
        pinView.rightCalloutAccessoryView = btPin
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let title = view.annotation?.title!, let subtitle = view.annotation?.subtitle! {
            alert(withTitle: title , message: subtitle)
        }

    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.showAnnotations([mapView.userLocation], animated: true)
    }
    
}
