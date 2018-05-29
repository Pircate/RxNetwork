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

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: Response {
    
    public func mapResult<T: Codable>(_ type: T.Type,
                                      atKeyPath keyPath: String? = nil,
                                      using decoder: JSONDecoder = .init()) -> Single<T> {
        return flatMap { response -> Single<T> in
            if let resp = try? response.map(TestResponse<T>.self) {
                if resp.success {
                    return Single.just(resp.result)
                }
                return Single.error(Network.Error.status(code: resp.code, message: resp.message))
            }
            return Single.error(MoyaError.jsonMapping(response))
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: TargetType {
    
    public func requestWithResult<T: Codable>(_ type: T.Type,
                                              atKeyPath keyPath: String? = nil,
                                              using decoder: JSONDecoder = .init()) -> Single<T> {
        return flatMap({ target -> Single<T> in
            target.request().map(TestResponse<T>.self, atKeyPath: keyPath, using: decoder).map({
                if $0.success { return $0.result }
                throw Network.Error.status(code: $0.code, message: $0.message)
            }).storeCachedObject(for: target)
        })
    }
}

extension ObservableType where E: TargetType {
    
    public func requestWithResult<T: Codable>(_ type: T.Type,
                                              atKeyPath keyPath: String? = nil,
                                              using decoder: JSONDecoder = .init()) -> Observable<T> {
        return flatMap { target -> Observable<T> in
            let result = target.request().map(TestResponse<T>.self, atKeyPath: keyPath, using: decoder).map({ response -> T in
                if response.success { return response.result }
                throw Network.Error.status(code: response.code, message: response.message)
            }).storeCachedObject(for: target).asObservable()
            
            if let object = target.cachedObject(type) {
                return result.startWith(object)
            }
            return result
        }
    }
}
