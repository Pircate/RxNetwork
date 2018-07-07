//
//  Network.swift
//  RxNetwork
//
//  Created by Pircate on 2018/4/17.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import Result

public final class Network {
    
    public static let `default`: Network = {
        Network(configuration: Configuration())
    }()
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public let configuration: Configuration
    
    public private(set) lazy var provider: MoyaProvider<MultiTarget> = {
        MoyaProvider(configuration: configuration)
    }()
}

public extension MoyaProvider {
    
    convenience init(configuration: Network.Configuration) {
        self.init(endpointClosure: { (target) -> Endpoint in
            MoyaProvider.defaultEndpointMapping(for: target).replacing(task: configuration.taskClosure(target))
        }, requestClosure: { (endpoint, callback) -> Void in
            if var request = try? endpoint.urlRequest() {
                request.timeoutInterval = configuration.timeoutInterval
                callback(.success(request))
            }
        }, plugins: configuration.plugins)
    }
}
