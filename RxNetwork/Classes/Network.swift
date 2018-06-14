//
//  Network.swift
//  RxNetwork
//
//  Created by GorXion on 2018/4/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Moya
import Result
import Cache

public let kNetworkTimeoutInterval: TimeInterval = 60

public final class Network {
    
    public var taskClosure: (TargetType) -> Task = { $0.task }
    
    public var timeoutInterval: TimeInterval = kNetworkTimeoutInterval
    
    public var plugins: [PluginType] = []
    
    public static let `default` = Network()
    
    public init() {}
    
    public lazy var provider: MoyaProvider<MultiTarget> = {
        MoyaProvider<MultiTarget>(taskClosure: taskClosure, timeoutInterval: timeoutInterval, plugins: plugins)
    }()
}

public extension Network {
    
    static let storage = try? Storage(diskConfig: DiskConfig(name: "RxNetworkResponseCache"),
                                      memoryConfig: MemoryConfig(),
                                      transformer: Transformer<Response>(
                                        toData: { $0.data },
                                        fromData: { Response(statusCode: 200, data: $0) }))
}

extension MoyaProvider {
    
    public convenience init(taskClosure: @escaping (TargetType) -> Task = { $0.task },
                            timeoutInterval: TimeInterval = kNetworkTimeoutInterval,
                            plugins: [PluginType] = []) {
        self.init(endpointClosure: { (target) -> Endpoint in
            MoyaProvider.defaultEndpointMapping(for: target).replacing(task: taskClosure(target))
        }, requestClosure: { (endpoint, callback) -> Void in
            if var request = try? endpoint.urlRequest() {
                request.timeoutInterval = timeoutInterval
                callback(.success(request))
            }
        }, plugins: plugins)
    }
}
