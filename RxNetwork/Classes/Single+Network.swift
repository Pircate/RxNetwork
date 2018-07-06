//
//  Single+Network.swift
//  RxNetwork
//
//  Created by Pircate on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya
import Cache

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: Codable {
    
    public func storeCachedObject(for target: TargetType) -> Single<ElementType> {
        return map { object -> ElementType in
            if let storage = try? Storage(diskConfig: DiskConfig(name: "RxNetworkObjectCache"),
                                          memoryConfig: MemoryConfig(),
                                          transformer: TransformerFactory.forCodable(ofType: ElementType.self)) {
                try? storage.setObject(object, forKey: target.cachedKey)
            }
            return object
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func storeCachedResponse(for target: TargetType) -> Single<Response> {
        return map { response -> Response in
            if Network.Configuration.default.storagePolicyClosure(response) {
                try? Network.storage?.setObject(response, forKey: target.cachedKey)
            }
            return response
        }
    }
}
