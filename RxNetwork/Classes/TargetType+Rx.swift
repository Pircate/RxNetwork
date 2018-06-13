//
//  TargetType+Rx.swift
//  RxNetwork
//
//  Created by GorXion on 2018/4/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import Moya
import Cache

public extension TargetType {
    
    internal var cachedKey: String {
        return "\(URL(target: self).absoluteString)?\(task.parameters)"
    }
    
    func request() -> Single<Response> {
        return Network.default.provider.rx.request(.target(self))
    }
    
    func cachedObject<T: Codable>(_ type: T.Type) -> T? {
        if let storage = try? Storage(diskConfig: DiskConfig(name: "RxNetworkCache"),
                                      memoryConfig: MemoryConfig(),
                                      transformer: TransformerFactory.forCodable(ofType: type)),
            let object = try? storage.object(forKey: cachedKey) {
            return object
        }
        return nil
    }
    
    func onCache<T: Codable>(_ type: T.Type,
                             _ closure: (T) -> Void) -> Single<Self> {
        if let object = cachedObject(type) { closure(object) }
        return Single.just(self)
    }
    
    var cache: Observable<Self> {
        return Observable.just(self)
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
