// 
//  CacheableTargetType.swift
//  RxNetwork
//
//  Created by Pircate(gao497868860@gmail.com) on 2019/3/6
//  
//

import Moya

public protocol CacheableTargetType: TargetType, Cacheable, CachingKey {
}

extension CacheableTargetType {
    
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
