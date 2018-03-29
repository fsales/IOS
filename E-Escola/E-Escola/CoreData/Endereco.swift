//
//  Endereco.swift
//  E-Escola
//
//  Created by Fábio Sales on 07/01/2018.
//  Copyright © 2018 Fábio Sales. All rights reserved.
//

import UIKit
import CoreData

class Endereco: NSManagedObject {
    
    
    public func enderecoFormatado() -> String{
        var end:String = String()
        
        //escola.endereco?.descricao!), \(escola.endereco!.bairro!)
        
        if let descricao = self.descricao, let bairro = self.bairro, let municipio = self.municipio?.nome, let uf = self.municipio?.uf{
            end = "\(descricao), \(bairro) - \(municipio)-\(uf)"
        }
        
        
        
        return end
    }
    
    public class func salvar(escolaCodable escola: JSONPlaceHolder.Escola, AndContext context: NSManagedObjectContext) throws -> Endereco{
        let request: NSFetchRequest<Endereco> = Endereco.fetchRequest()
        request.predicate = NSPredicate(format: "codigo = %d", escola.codEscola)
        request.resultType = .managedObjectResultType
        
        if let result = try? context.fetch(request), result.count > 0{
            if result.count > 1 {
                throw IntegrityError(message: "[ Endereco ] Erro de Integridade: Mais de um objeto encontrado para um dado ID.", info: ["endereco": escola.endereco, "fetched": result])
            }
            
            return result.first!
        }
        
        let persitentEndereco = Endereco(context: context)
        let endercePlace: JSONPlaceHolder.Endereco = escola.endereco
        persitentEndereco.codigo = escola.codEscola
        persitentEndereco.bairro = endercePlace.bairro
        persitentEndereco.cep = endercePlace.cep
        persitentEndereco.descricao = endercePlace.descricao
        
        do{
            persitentEndereco.municipio = try Municipio.salvar(enderecoCodable: endercePlace, AndContext: context)
        }catch{
            throw error
        }
        
        return persitentEndereco
        
    }
}

