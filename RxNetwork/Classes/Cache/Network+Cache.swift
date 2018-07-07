//
//  Network+Cache.swift
//  RxNetwork
//
//  Created by Pircate on 2018/7/7.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Cache
import Moya

private let kNetworkObjectCacheName = "RxNetworkObjectCache"
private let kNetworkResponseCacheName = "RxNetworkResponseCache"

extension Network {
    
    public class Cache {
        
        public static let shared = Cache()
        
        public var storagePolicyClosure: (Response) -> Bool = { _ in true }
        
        private init() {}
    }
}

public extension Network.Cache {
    
    func removeAllCachedData() throws {
        try removeAllCachedObjects()
        try removeAllCachedResponses()
    }
}

public extension Network.Cache {
    
    func cachedObject<C: Codable>(_ type: C.Type, for target: TargetType) throws -> C {
        return try Storage<C>().object(forKey: target.cachedKey)
    }
    
    func storeCachedObject<C: Codable>(_ cachedObject: C, for target: TargetType) throws {
        try Storage<C>().setObject(cachedObject, forKey: target.cachedKey)
    }
    
    func removeCachedObject<C: Codable>(_ type: C.Type, for target: TargetType) throws {
        try Storage<C>().removeObject(forKey: target.cachedKey)
    }
    
    private func removeAllCachedObjects() throws {
        try Storage<String>().removeAll()
    }
}

public extension Network.Cache {
    
    func cachedResponse(for target: TargetType) throws -> Response {
        return try Storage<Response>().object(forKey: target.cachedKey)
    }
    
    func storeCachedResponse(_ cachedResponse: Response, for target: TargetType) throws {
        try Storage<Response>().setObject(cachedResponse, forKey: target.cachedKey)
    }
    
    func removeCachedResponse(for target: TargetType) throws {
        try Storage<Response>().removeObject(forKey: target.cachedKey)
    }
    
    private func removeAllCachedResponses() throws {
        try Storage<Response>().removeAll()
    }
}

fileprivate extension Storage where T: Codable {
    
    convenience init() throws {
        try self.init(diskConfig: DiskConfig(name: kNetworkObjectCacheName),
                      memoryConfig: MemoryConfig(),
                      transformer: TransformerFactory.forCodable(ofType: T.self))
    }
}

fileprivate extension Storage where T == Response {
    
    convenience init() throws {
       try self.init(diskConfig: DiskConfig(name: kNetworkResponseCacheName),
                     memoryConfig: MemoryConfig(),
                     transformer: Transformer<Response>(
                        toData: { $0.data },
                        fromData: { Response(statusCode: 200, data: $0) }))
    }
}
