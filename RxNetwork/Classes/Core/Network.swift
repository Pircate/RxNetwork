//
//  Network.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/4/17.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import Result

open class Network {
    
    public static let `default`: Network = {
        Network(configuration: Configuration.default)
    }()
    
    public let provider: MoyaProvider<MultiTarget>
    
    public init(configuration: Configuration) {
        provider = MoyaProvider(configuration: configuration)
    }
}

public extension MoyaProvider {
    
    convenience init(configuration: Network.Configuration) {
        
        let endpointClosure = { target -> Endpoint in
            MoyaProvider.defaultEndpointMapping(for: target)
                .adding(newHTTPHeaderFields: configuration.addingHeaders(target))
                .replacing(task: configuration.replacingTask(target))
        }
        
        let requestClosure =  { (endpoint: Endpoint, closure: RequestResultClosure) -> Void in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = configuration.timeoutInterval
                closure(.success(request))
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(.parameterEncoding(error)))
            } catch {
                closure(.failure(.underlying(error, nil)))
            }
        }
        
        self.init(endpointClosure: endpointClosure,
                  requestClosure: requestClosure,
                  plugins: configuration.plugins)
    }
}
