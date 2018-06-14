//
//  Network+Rx.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/5/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import RxNetwork
import RxSwift
import Moya

extension Network {
    
    enum Error: Swift.Error {
        case unknown
        case status(code: Int, message: String)
    }
}

extension Network {
    
    struct Response<T: Codable>: Codable {
        let code: Int
        let message: String
        let result: T
        
        var success: Bool {
            return code == 2000
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: Response {
    
    public func mapResult<T: Codable>(_ type: T.Type,
                                      atKeyPath keyPath: String? = nil,
                                      using decoder: JSONDecoder = .init()) -> Single<T> {
        return flatMap { response -> Single<T> in
            if let resp = try? response.map(Network.Response<T>.self) {
                if resp.success {
                    return Single.just(resp.result)
                }
                return Single.error(Network.Error.status(code: resp.code, message: resp.message))
            }
            return Single.error(MoyaError.jsonMapping(response))
        }
    }
}

extension ObservableType where E == Response {
    
    public func mapResult<T: Codable>(_ type: T.Type,
                                      atKeyPath keyPath: String? = nil,
                                      using decoder: JSONDecoder = .init()) -> Observable<T> {
        return map { response -> T in
            if let resp = try? response.map(Network.Response<T>.self) {
                if resp.success {
                    return resp.result
                }
                throw Network.Error.status(code: resp.code, message: resp.message)
            }
            throw MoyaError.jsonMapping(response)
        }
    }
}

extension OnCache {
    
    public func requestWithResult() -> Single<C> {
        return target.request().map(Network.Response<C>.self).map({
            if $0.success { return $0.result }
            throw Network.Error.status(code: $0.code, message: $0.message)
        }).storeCachedObject(for: target)
    }
}
