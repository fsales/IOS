//
//  Municipio.swift
//  E-Escola
//
//  Created by Fábio Sales on 23/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import CoreData

class Municipio: NSManagedObject {
    
    public class func salvar(enderecoCodable endereco: JSONPlaceHolder.Endereco, AndContext context: NSManagedObjectContext) throws -> Municipio{
        let request: NSFetchRequest<Municipio> = Municipio.fetchRequest()
        
        let ufPredicate = NSPredicate(format: "uf = %@", endereco.uf)
        let municipioPredicate = NSPredicate(format: "nome = %@", endereco.municipio)
        let predicates = NSCompoundPredicate(type: .and , subpredicates: [ufPredicate, municipioPredicate])
        request.predicate = predicates
        request.resultType = .managedObjectResultType
        
        if let result = try? context.fetch(request), result.count > 0{
            if result.count > 1 {
                throw IntegrityError(message: "[ Municipio ] Erro de Integridade: Mais de um objeto encontrado para um dado ID.", info: ["municipio": endereco.municipio, "uf": endereco.uf , "fetched": result])
            }
            
            return result.first!
        }
        
        let persitentMunicipio = Municipio(context: context)
        persitentMunicipio.codigo = UUID().uuidString.lowercased()
        persitentMunicipio.uf = endereco.uf
        persitentMunicipio.nome = endereco.municipio
        
        
        return persitentMunicipio
        
        
    }
    
}

