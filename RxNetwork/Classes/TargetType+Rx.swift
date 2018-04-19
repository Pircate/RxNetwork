//
//  TargetType+Rx.swift
//  Network
//
//  Created by GorXion on 2018/4/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import Moya

extension TargetType {
    
    @available(iOS 9.0, *)
    public var cachedKey: String {
        func parameter(task: Task) -> String {
            switch task {
            case .requestParameters(let parameters, _):
                return "\(parameters)"
            case let .requestCompositeParameters(bodyParameters, _, urlParameters):
                return "\(bodyParameters)\(urlParameters)"
            default:
                return ""
            }
        }
        return "\(URL(fileURLWithPath: path, relativeTo: baseURL).absoluteString)?\(parameter(task: task))"
    }
    
    public func request() -> Single<Response> {
        return Network.provider.rx.request(.target(self))
    }
    
    public func request<T: Codable>(_ type: T.Type,
                                    atKeyPath keyPath: String? = nil,
                                    using decoder: JSONDecoder = .init()) -> Single<T> {
        return request().map(type, atKeyPath: keyPath, using: decoder)
    }
    
    @available(iOS 9.0, *)
    public func cachedObject<T: Codable>(_ type: T.Type,
                                         onCache: (T) -> Void) -> Single<Self> {
        if let entry = try? Network.storage?.entry(ofType: type, forKey: cachedKey), let object = entry?.object {
            onCache(object)
        }
        return Single.just(self)
    }
    
    public var cache: Observable<Self> {
        return Observable.just(self)
    }
}
