//
//  Network.swift
//  RxNetwork
//
//  Created by Pircate on 2018/4/17.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import Result
import Cache

public let kNetworkTimeoutInterval: TimeInterval = 60

public final class Network {
    
    public let provider: MoyaProvider<MultiTarget>
    
    public static let `default`: Network = {
        Network(configuration: Network.Configuration.default)
    }()
    
    public init(configuration: Configuration) {
        provider = MoyaProvider(configuration: configuration)
    }
}

public extension Network {
    
    class Configuration {
        
        public var taskClosure: (TargetType) -> Task = { $0.task }
        
        public var timeoutInterval: TimeInterval = kNetworkTimeoutInterval
        
        public var plugins: [PluginType] = []
        
        public var storagePolicyClosure: (Response) -> Bool = { _ in true }
        
        public static var `default` = Configuration()
        
        public init() {}
    }
}

public extension Network {
    
    static let storage = try? Storage(diskConfig: DiskConfig(name: "RxNetworkResponseCache"),
                                      memoryConfig: MemoryConfig(),
                                      transformer: Transformer<Response>(
                                        toData: { $0.data },
                                        fromData: { Response(statusCode: 200, data: $0) }))
}

extension MoyaProvider {
    
    public convenience init(configuration: Network.Configuration) {
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
