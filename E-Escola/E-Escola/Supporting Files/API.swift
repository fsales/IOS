//
//  API.swift
//  E-Escola
//
//  Created by Fábio Sales on 23/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import Foundation

struct API {
    
    static let baseURL = "http://mobile-aceite.tcu.gov.br:80/nossaEscolaRS"
    static let raioLocalizacao = "10"
    
    static func escola(_ latitude:Double, _ longitude:Double) -> String{

        return baseURL + "/rest/escolas/latitude/" + String(latitude) + "/longitude/" + String(longitude) + "/raio/" + raioLocalizacao + "?campos=codEscola,nome,latitude,longitude,rede,email,esferaAdministrativa,endereco&quantidadeDeItens=20"
    }
}

struct ContentType {
    
    public static let ApplicationJSON = "application/json"
    public static let UTF_8 = "UTF-8"
    
}

struct HTTPHeader {
    public static let ContentType = "Content-Type"
    public static let Accept = "Accept"
    public static let Get = "GET"
    public static let Charset = "Charset"
}
