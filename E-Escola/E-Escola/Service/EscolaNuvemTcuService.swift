//
//  EscolaNuvemTcuService.swift
//  E-Escola
//
//  Created by Fábio Sales on 31/12/2017.
//  Copyright © 2017 Fábio Sales. All rights reserved.
//

import UIKit
import CoreLocation

protocol EscolaNuvemTcu: class {
    func getEscola(_ escolas:[JSONPlaceHolder.Escola]?, error: Error?)
}

class EscolaNuvemTcuService: NSObject {
    
    weak var delegate: EscolaNuvemTcu?
    
    private static var instacia: EscolaNuvemTcuService = {
        let instaciaTemp = EscolaNuvemTcuService()
        return instaciaTemp
    }()
    
    private lazy var appendingDataEscolas:Data = {[weak self] in
        return Data()
        }()
    
    private lazy var session: URLSession = { [weak self] in
        
        let cfg = URLSessionConfiguration.default
        cfg.allowsCellularAccess = true
        cfg.networkServiceType = .default
        cfg.requestCachePolicy = .returnCacheDataElseLoad
        cfg.isDiscretionary = true
        cfg.urlCache = URLCache(memoryCapacity: 0,
                                diskCapacity: 10,
                                diskPath: NSTemporaryDirectory())
        
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        queue.maxConcurrentOperationCount = 5
        queue.underlyingQueue = DispatchQueue.global(qos: .userInteractive)
        
        let session = URLSession(configuration: cfg,
                                 delegate: self,
                                 delegateQueue: queue)
        return session
        }()
    
    private override init() {
        super.init()
    }
    
    class func shared() -> EscolaNuvemTcuService {
        return instacia
    }
    
    public func buscarEscolas(_ coordenadas: CLLocationCoordinate2D){
        
        if let url = URL(string: API.escola(coordenadas.latitude, coordenadas.longitude)){
            var request = URLRequest(url: url)
            request.timeoutInterval = 15
            request.addValue("2", forHTTPHeaderField: "x-api-version")
            request.httpMethod = HTTPHeader.Get
            request.setValue(ContentType.ApplicationJSON, forHTTPHeaderField: HTTPHeader.Accept)
            request.setValue(ContentType.ApplicationJSON, forHTTPHeaderField: HTTPHeader.ContentType)
            request.setValue(ContentType.UTF_8, forHTTPHeaderField: HTTPHeader.Charset)
            
            let dataTask = session.dataTask(with: request)
            dataTask.resume()
        }
        
    }
}

extension EscolaNuvemTcuService: URLSessionDataDelegate, URLSessionDelegate{
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        appendingDataEscolas.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let er = error{
            self.delegate?.getEscola(nil, error: er)
            return
        }
        
        JSONPlaceHolder.Escola.decode(self.appendingDataEscolas) { (escolas, erro) in
            self.delegate?.getEscola(escolas, error: error)
        }
    }
    
}

