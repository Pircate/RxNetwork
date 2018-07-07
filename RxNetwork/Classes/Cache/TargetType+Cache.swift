//
//  TargetType+Cache.swift
//  RxNetwork
//
//  Created by Pircate on 2018/7/7.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import Cache
import RxSwift

public extension TargetType {
    
    func onCache<C: Codable>(_ type: C.Type,
                             _ closure: (C) -> Void) -> OnCache<Self, C> {
        if let object = try? cachedObject(type) { closure(object) }
        return OnCache(self)
    }

    func cachedObject<C: Codable>(_ type: C.Type) throws -> C {
        return try Network.Cache.shared.cachedObject(type, for: self)
    }
    
    func storeCachedObject<C: Codable>(_ cachedObject: C) throws {
        try Network.Cache.shared.storeCachedObject(cachedObject, for: self)
    }

    func removeCachedObject<C: Codable>(_ type: C.Type) throws {
        try Network.Cache.shared.removeCachedObject(type, for: self)
    }
}

public extension TargetType {
    
    var cache: Observable<Self> {
        return Observable.just(self)
    }
    
    func cachedResponse() throws -> Response {
        return try Network.Cache.shared.cachedResponse(for: self)
    }
    
    func storeCachedResponse(_ cachedResponse: Response) throws {
        try Network.Cache.shared.storeCachedResponse(cachedResponse, for: self)
    }
    
    func removeCachedResponse() throws {
        try Network.Cache.shared.removeCachedResponse(for: self)
    }
}

extension TargetType {
    
    var cachedKey: String {
        return "\(URL(target: self).absoluteString)?\(task.parameters)"
    }
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
