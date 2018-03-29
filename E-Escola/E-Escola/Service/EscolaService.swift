//
//  EscolaService.swift
//  E-Escola
//
//  Created by Fábio Sales on 31/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import CoreLocation

protocol  EscolaDelegate {
    func resultadoEscolaCoreData(_ escolas: [Escola]? ,error:Error?);
}

class EscolaService: NSObject {
    
    public static let CHAVE_USER_INFO = "BUSCAR_ESCOLAS"
    var delegate: EscolaDelegate?
    private var persistentContainer = AppDelegate.persistentContainer
    private var coordenadaTemp:CLLocationCoordinate2D?
    private static var instacia: EscolaService = {
        let instaciaTemp = EscolaService()
        return instaciaTemp
    }()
    
    private lazy var escolaNuvemTcu:EscolaNuvemTcuService = {[weak self ] in
        return EscolaNuvemTcuService.shared()
        }()
    
    private override init() {
        super.init()
        escolaNuvemTcu.delegate = self
    }
    
    class func shared() -> EscolaService {
        return instacia
    }
    
    public func buscarEscolas(_ coordenadas: CLLocationCoordinate2D){
        coordenadaTemp = coordenadas
        escolaNuvemTcu.buscarEscolas(coordenadas)
    }
    
    private func buscarEscolaCoreData(_ coordenada:CLLocationCoordinate2D){
        persistentContainer.performBackgroundTask{ [unowned self] (context) in
            do{
                if let localizacao = try LocalizacaoDispotivo.getLocalizacao(coordenada, AndContext: context){
                    
                    let escolasTemp:[Escola] = (localizacao.escolas?.allObjects as! [Escola])
                    let newSortedArray = escolasTemp.sorted(by: { $0.nome?.localizedCaseInsensitiveCompare($1.nome!) == ComparisonResult.orderedAscending})
                    // print(newSortedArray)
                    self.delegate?.resultadoEscolaCoreData(newSortedArray,error: nil)
                    let userInfo : NSDictionary = [EscolaService.CHAVE_USER_INFO : newSortedArray]
                    NotificationCenter.default.post(name: NSNotification.Name.EscolaFetched, object: self, userInfo: userInfo as [NSObject : AnyObject])
                }
            }catch{
                self.delegate?.resultadoEscolaCoreData(nil,error: error)
            }
        }
    }
}

extension EscolaService :EscolaNuvemTcu{
    func getEscola(_ escolas: [JSONPlaceHolder.Escola]?, error: Error?) {
        persistentContainer.performBackgroundTask{ [unowned self] (context) in
            
            do{
                if let escolasTemp = escolas{
                    let locTemp = try LocalizacaoDispotivo.salvar(self.coordenadaTemp!, escolasTemp, AndContext: context)
                    _ = try Escola.salvar(escolaCodable: escolasTemp , locTemp, AndContext: context)
                    try context.save()
                    
                }
            } catch{
                self.delegate?.resultadoEscolaCoreData(nil,error: error)
            }
            self.buscarEscolaCoreData(self.coordenadaTemp!)
        }
        
        
    }
}


