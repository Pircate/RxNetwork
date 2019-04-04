//
//  TargetType+Cache.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/7/7.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import RxSwift

public extension TargetType where Self: Cacheable {
    
    func onCache<C: Codable>(
        _ type: C.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder = .init(),
        _ closure: (C) -> Void)
        -> OnCache<Self, C>
    {
        if let object = try? cachedResponse()
            .map(type, atKeyPath: keyPath, using: decoder) {
            closure(object)
        }
        
        return OnCache(target: self, keyPath: keyPath, decoder: decoder)
    }
}

public extension TargetType where Self: Cacheable {
    
    var cache: Observable<Self> {
        return Observable.just(self)
    }
    
    func cachedResponse() throws -> Moya.Response {
        return try cachedResponse(for: self)
    }
    
    func storeCachedResponse(_ cachedResponse: Moya.Response) throws {
        try storeCachedResponse(cachedResponse, for: self)
    }
    
    func removeCachedResponse() throws {
        try removeCachedResponse(for: self)
    }
}
