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
    
    func cachedObject<C: Codable>(_ type: C.Type, for target: TargetType) throws -> C {
        let storage = try Storage(diskConfig: DiskConfig(name: kNetworkObjectCacheName),
                                  memoryConfig: MemoryConfig(),
                                  transformer: TransformerFactory.forCodable(ofType: type))
        return try storage.object(forKey: target.cachedKey)
    }
    
    func storeCachedObject<C: Codable>(_ cachedObject: C, for target: TargetType) throws {
        let storage = try Storage(diskConfig: DiskConfig(name: kNetworkObjectCacheName),
                                  memoryConfig: MemoryConfig(),
                                  transformer: TransformerFactory.forCodable(ofType: C.self))
        try storage.setObject(cachedObject, forKey: target.cachedKey)
    }
    
    func removeCachedObject<C: Codable>(_ type: C.Type, for target: TargetType) throws {
        let storage = try Storage(diskConfig: DiskConfig(name: kNetworkObjectCacheName),
                                  memoryConfig: MemoryConfig(),
                                  transformer: TransformerFactory.forCodable(ofType: type))
        try storage.removeObject(forKey: target.cachedKey)
    }
    
    func removeAllCachedObjects() throws {
        // TODO: - removeAllCachedObjects
    }
}

public extension Network.Cache {
    
    func cachedResponse(for target: TargetType) throws -> Response {
        let storage = try Storage(diskConfig: DiskConfig(name: kNetworkResponseCacheName),
                                  memoryConfig: MemoryConfig(),
                                  transformer: Transformer<Response>(
                                    toData: { $0.data },
                                    fromData: { Response(statusCode: 200, data: $0) }))
        return try storage.object(forKey: target.cachedKey)
    }
    
    func storeCachedResponse(_ cachedResponse: Response, for target: TargetType) throws {
        let storage = try Storage(diskConfig: DiskConfig(name: kNetworkResponseCacheName),
                                  memoryConfig: MemoryConfig(),
                                  transformer: Transformer<Response>(
                                    toData: { $0.data },
                                    fromData: { Response(statusCode: 200, data: $0) }))
        try storage.setObject(cachedResponse, forKey: target.cachedKey)
    }
    
    func removeCachedResponse(for target: TargetType) throws {
        let storage = try Storage(diskConfig: DiskConfig(name: kNetworkResponseCacheName),
                                  memoryConfig: MemoryConfig(),
                                  transformer: Transformer<Response>(
                                    toData: { $0.data },
                                    fromData: { Response(statusCode: 200, data: $0) }))
        try storage.removeObject(forKey: target.cachedKey)
    }
    
    func removeAllCachedResponses() throws {
        let storage = try Storage(diskConfig: DiskConfig(name: kNetworkResponseCacheName),
                                  memoryConfig: MemoryConfig(),
                                  transformer: Transformer<Response>(
                                    toData: { $0.data },
                                    fromData: { Response(statusCode: 200, data: $0) }))
        try storage.removeAll()
    }
}
