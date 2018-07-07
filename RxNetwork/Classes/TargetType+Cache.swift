//
//  TargetType+Cache.swift
//  RxNetwork
//
//  Created by Pircate on 2018/7/7.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import RxSwift
import Cache

public extension TargetType {
    
    internal var cachedKey: String {
        return "\(URL(target: self).absoluteString)?\(task.parameters)"
    }
    
    func cachedObject<T: Codable>(_ type: T.Type) -> T? {
        if let storage = try? Storage(diskConfig: DiskConfig(name: "RxNetworkObjectCache"),
                                      memoryConfig: MemoryConfig(),
                                      transformer: TransformerFactory.forCodable(ofType: type)),
            let object = try? storage.object(forKey: cachedKey) {
            return object
        }
        return nil
    }
    
    var cachedResponse: Response? {
        if let response = try? Network.storage?.object(forKey: cachedKey) {
            return response
        }
        return nil
    }
    
    func onCache<T: Codable>(_ type: T.Type,
                             _ closure: (T) -> Void) -> OnCache<Self, T> {
        if let object = cachedObject(type) { closure(object) }
        return OnCache(self)
    }
    
    var cache: Observable<Self> {
        return Observable.just(self)
    }
}

extension Network {
    
    static let storage = try? Storage(diskConfig: DiskConfig(name: "RxNetworkResponseCache"),
                                      memoryConfig: MemoryConfig(),
                                      transformer: Transformer<Response>(
                                        toData: { $0.data },
                                        fromData: { Response(statusCode: 200, data: $0) }))
}

fileprivate extension Task {
    
    var parameters: String {
        switch self {
        case .requestParameters(let parameters, _):
            return "\(parameters)"
        case .requestCompositeData(_, let urlParameters):
            return "\(urlParameters)"
        case let .requestCompositeParameters(bodyParameters, _, urlParameters):
            return "\(bodyParameters)\(urlParameters)"
        default:
            return ""
        }
    }
}
