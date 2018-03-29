//
//  LocalizacaoDispotivo.swift
//  E-Escola
//
//  Created by Fábio Sales on 23/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocalizacaoDispotivo: NSManagedObject {
    
    public class func salvar(_ coordenada: CLLocationCoordinate2D, _ escolas: [JSONPlaceHolder.Escola] ,AndContext context: NSManagedObjectContext) throws -> LocalizacaoDispotivo{
        if let cordenadaExistente = try? self.getLocalizacao(coordenada, AndContext: context), cordenadaExistente != nil {
            return cordenadaExistente!
        }
        
        let loc:LocalizacaoDispotivo = LocalizacaoDispotivo(context: context)
        loc.codigo = UUID().uuidString.lowercased()
        loc.longitude = String(coordenada.longitude)
        loc.latitude = String(coordenada.latitude)
        
        return loc
    }
    
    public class func getLocalizacao(_ coordenada: CLLocationCoordinate2D, AndContext context: NSManagedObjectContext) throws -> LocalizacaoDispotivo?{
        let request: NSFetchRequest<LocalizacaoDispotivo> = LocalizacaoDispotivo.fetchRequest()
        
        let latitudePredicate = NSPredicate(format: "latitude = %@", String(coordenada.latitude))
        let longitudePredicate = NSPredicate(format: "longitude = %@", String(coordenada.longitude))
        let predicates = NSCompoundPredicate(type: .and , subpredicates: [latitudePredicate, longitudePredicate])
        request.predicate = predicates
        request.resultType = .managedObjectResultType
        
        var locRetorno:LocalizacaoDispotivo?
        if let result = try? context.fetch(request), result.count > 0{
            locRetorno = result.first!
        }
        
        return locRetorno
    }
    
}

