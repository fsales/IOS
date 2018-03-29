//
//  JsonPlaceHolderModel.swift
//  E-Escola
//
//  Created by Fábio Sales on 19/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import Foundation

struct JSONPlaceHolder {
    struct Escola: Codable {
        var codEscola: Int32
        var nome: String
        var latitude: Double
        var longitude: Double
        var rede: String
        var email: String?
        var esferaAdministrativa: String
        var endereco: Endereco
        
        public static func decode(_ data:Data, _ calback: @escaping(_ escolas:[JSONPlaceHolder.Escola]?, _ error: Error?) -> Void){
            var escolas: [JSONPlaceHolder.Escola]?
            var erro: Error?
            do {
                let decoder = JSONDecoder()
                decoder.nonConformingFloatDecodingStrategy = .convertFromString(
                    positiveInfinity: "+Infinity",
                    negativeInfinity: "-Infinity",
                    nan: "NaN"
                )
                
                escolas = try decoder.decode([JSONPlaceHolder.Escola].self, from: data)
            } catch DecodingError.dataCorrupted(let context) {
                print(context.debugDescription)
                erro = context.underlyingError
            } catch DecodingError.keyNotFound(let key, let context) {
                print("\(key.stringValue) was not found, \(context.debugDescription)")
                erro = context.underlyingError
            } catch DecodingError.typeMismatch(let type, let context) {
                print("\(type) was expected, \(context.debugDescription)")
                erro = context.underlyingError
            } catch DecodingError.valueNotFound(let type, let context) {
                print("no value was found for \(type), \(context.debugDescription)")
                erro = context.underlyingError
            } catch {
                erro = error
            }
            
            calback(escolas, erro)
        }
    }
    
    struct Endereco: Codable {
        var cep: String
        var descricao: String
        var bairro: String
        var municipio: String
        var uf: String
    }
    
    
}

