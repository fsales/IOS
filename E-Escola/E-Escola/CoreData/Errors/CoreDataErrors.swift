//
//  CoreDataErrors.swift
//  E-Escola
//
//  Created by Fábio Sales on 23/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import Foundation

protocol CoreDataError : Error {
    var message: String { get }
    var info: [String:Any]? { get }
}

struct IntegrityError: CoreDataError {
    var message: String
    var info: [String : Any]?
}
