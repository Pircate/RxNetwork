//
//  TargetType+Rx.swift
//  RxNetwork
//
//  Created by GorXion on 2018/4/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import Moya

public extension TargetType {
    
    var cachedKey: String {
        return "\(URL(target: self).absoluteString)?\(task.parameters)"
    }
    
    func request() -> Single<Response> {
        return Network.provider.rx.request(.target(self))
    }
    
    func request<T: Codable>(_ type: T.Type,
                             atKeyPath keyPath: String? = nil,
                             using decoder: JSONDecoder = .init()) -> Single<T> {
        return request().map(type, atKeyPath: keyPath, using: decoder)
    }
    
    func cachedObject<T: Codable>(_ type: T.Type,
                                  onCache: (T) -> Void) -> Single<Self> {
        if let entry = try? Network.storage?.entry(ofType: type, forKey: cachedKey), let object = entry?.object {
            onCache(object)
        }
        return Single.just(self)
    }
    
    var cache: Observable<Self> {
        return Observable.just(self)
    }
}

extension Task {
    
    public var parameters: String {
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
