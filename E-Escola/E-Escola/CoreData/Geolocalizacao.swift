//
//  Geolocalizacao.swift
//  E-Escola
//
//  Created by Fábio Sales on 23/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class Geolocalizacao: NSManagedObject {
    
    func asLocationCoordinate() -> CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public class func salvar(escolaCodable escola: JSONPlaceHolder.Escola, AndContext context: NSManagedObjectContext) throws -> Geolocalizacao{
        let request: NSFetchRequest<Geolocalizacao> = Geolocalizacao.fetchRequest()
        request.predicate = NSPredicate(format: "codigo = %d", escola.codEscola)
        request.resultType = .managedObjectResultType
        
        if let result = try? context.fetch(request), result.count > 0{
            if result.count > 1 {
                throw IntegrityError(message: "[ Geolocalizacao ] Erro de Integridade: Mais de um objeto encontrado para um dado ID.", info: ["geolocalizaco": escola.codEscola, "fetched": result])
            }
            
            return result.first!
        }
        
        let persitentGeo = Geolocalizacao(context: context)
        persitentGeo.codigo = UUID().uuidString.lowercased()
        persitentGeo.latitude = escola.latitude
        persitentGeo.longitude = escola.longitude
        return persitentGeo
        
    }
}

