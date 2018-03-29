//
//  Escola.swift
//  E-Escola
//
//  Created by Fábio Sales on 23/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import CoreData

class Escola: NSManagedObject {
    
    public class func salvar(escolaCodable escolas: [JSONPlaceHolder.Escola], _ localizacao:LocalizacaoDispotivo, AndContext context: NSManagedObjectContext) throws -> [Escola]{
        var escolasTemp:[Escola] =  [Escola]()
        
        for escola in escolas{
            if let esc = try? salvar(escolaCodable: escola, localizacao, AndContext: context){
                escolasTemp.append(esc)
            }
        }
        
        return escolasTemp
    }
    
    public class func salvar(escolaCodable escola: JSONPlaceHolder.Escola,_ localizacao:LocalizacaoDispotivo, AndContext context: NSManagedObjectContext) throws -> Escola{
        let request: NSFetchRequest<Escola> = Escola.fetchRequest()
        request.predicate = NSPredicate(format: "codigo = %d", escola.codEscola)
        request.resultType = .managedObjectResultType
        
        do{
            if let result = try? context.fetch(request), result.count > 0{
                if result.count > 1 {
                    throw IntegrityError(message: "[ Escola ] Erro de Integridade: Mais de um objeto encontrado para um dado ID.", info: ["ecola": escola, "fetched": result])
                }
                
                return result.first!
            }
            
        } catch{
            throw error
        }
        
        
        let persitentEscola = Escola(context: context)
        persitentEscola.codigo = escola.codEscola
        persitentEscola.email = escola.email
        persitentEscola.esfera = escola.esferaAdministrativa
        persitentEscola.nome = escola.nome
        persitentEscola.rede = escola.rede
        
        
        persitentEscola.localizacoesDispositivo =  persitentEscola.localizacoesDispositivo?.adding(localizacao as LocalizacaoDispotivo) as NSSet?
        
        do{
            persitentEscola.endereco = try Endereco.salvar(escolaCodable: escola, AndContext: context)
            persitentEscola.geo = try Geolocalizacao.salvar(escolaCodable: escola, AndContext: context)
        }catch{
            throw error
        }
        
        return persitentEscola
    }
    
}

