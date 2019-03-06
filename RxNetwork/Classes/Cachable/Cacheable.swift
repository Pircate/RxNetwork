// 
//  Cacheable.swift
//  RxNetwork
//
//  Created by Pircate(gao497868860@gmail.com) on 2019/3/5
//  
//

import Moya

public protocol Cacheable {
    
    var allowsStorage: (Moya.Response) -> Bool { get }
    
    func cachedResponse(for key: CachingKey) throws -> Moya.Response
    
    func storeCachedResponse(_ cachedResponse: Moya.Response, for key: CachingKey) throws
    
    func removeCachedResponse(for key: CachingKey) throws
    
    func removeAllCachedResponses() throws
}

public protocol CachingKey {
    var stringValue: String { get }
}
