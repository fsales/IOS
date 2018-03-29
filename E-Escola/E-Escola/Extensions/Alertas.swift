//
//  Alertas.swift
//  E-Escola
//
//  Created by Fábio Sales on 23/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit

extension UIViewController{
    func genericErrorAlert(_ error: Error) {
        alert(withTitle: "Erro!", message: error.localizedDescription)
        debugPrint(error)
    }
    
    func genericNSErrorAlert(_ error: NSError) {
        alert(withTitle: error.domain, message: error.localizedDescription)
        debugPrint(error)
    }
    
    func integrityErrorAlert(_ error: IntegrityError)  {
        alert(withTitle: "Erro de Integridade", message: error.message)
        if error.info != nil {
            print("Informações do erro:\n\(error.info!)")
        }
    }
    
    func alert(withTitle title: String, message: String, actions: [UIAlertAction]? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let alertActions = actions, alertActions.count > 0 {
            for action in alertActions {
                ac.addAction(action)
            }
        }else {
            ac.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: { (action) in
                                        ac.dismiss(animated: true, completion: nil)
            }))
        }
        present(ac, animated: true, completion: nil)
    }
}
