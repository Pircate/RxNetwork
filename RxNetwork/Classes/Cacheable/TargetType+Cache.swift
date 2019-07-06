//
//  TargetType+Cache.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/7/7.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import RxSwift
import Storable

public typealias CachingKey = StoringKey

public typealias Cacheable = Storable & StoringKey & Expirable

public extension Expirable {
    
    var expiry: Expiry {
        return .never
    }
}

public extension TargetType where Self: Cacheable, Self.ResponseType == Moya.Response {
    
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

public extension TargetType where Self: Cacheable, Self.ResponseType == Moya.Response {
    
    var cache: Observable<Self> {
        return Observable.just(self)
    }
    
    func cachedResponse() throws -> Moya.Response {
        let expiry = try self.expiry(for: self)
        
        guard expiry.isExpired else {
            let response = try cachedResponse(for: self)
            return Response(statusCode: response.statusCode, data: response.data)
        }
        
        throw Expiry.Error.expired(expiry.date)
    }
    
    func storeCachedResponse(_ cachedResponse: Moya.Response) throws {
        try storeCachedResponse(cachedResponse, for: self)
        
        update(expiry: expiry, for: self)
    }
    
    func removeCachedResponse() throws {
        try removeCachedResponse(for: self)
        
        removeExpiry(for: self)
    }
}
