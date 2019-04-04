// 
//  CachingKey.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/3/6
//  Copyright © 2019年 Pircate. All rights reserved.
//

import Moya

public protocol CachingKey {
    
    var stringValue: String { get }
}

extension CachingKey where Self: TargetType {
    
    public var stringValue: String {
        return cachedKey
    }
}

private extension TargetType {
    
    var cachedKey: String {
        if let urlRequest = try? endpoint.urlRequest(),
            let data = urlRequest.httpBody,
            let parameters = String(data: data, encoding: .utf8) {
            return "\(method.rawValue):\(endpoint.url)?\(parameters)"
        }
        return "\(method.rawValue):\(endpoint.url)"
    }
    
    var endpoint: Endpoint {
        return Endpoint(url: URL(target: self).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, self.sampleData) },
                        method: method,
                        task: task,
                        httpHeaderFields: headers)
    }
}
