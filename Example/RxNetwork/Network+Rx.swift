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
        case status(code: Int, message: String)
        
        var code: Int {
            switch self {
            case .status(let code, _):
                return code
            }
        }
        
        var message: String {
            switch self {
            case .status(_, let message):
                return message
            }
        }
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

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func mapObject<T: Codable>(_ type: T.Type,
                                      atKeyPath keyPath: String? = nil,
                                      using decoder: JSONDecoder = .init()) -> Single<T> {
        return map {
            guard let response = try? $0.map(Network.Response<T>.self) else {
                throw MoyaError.jsonMapping($0)
            }
            if response.success { return response.result }
            throw Network.Error.status(code: response.code, message: response.message)
        }
    }
}

extension ObservableType where E == Response {
    
    public func mapObject<T: Codable>(_ type: T.Type,
                                      atKeyPath keyPath: String? = nil,
                                      using decoder: JSONDecoder = .init()) -> Observable<T> {
        return map {
            guard let response = try? $0.map(Network.Response<T>.self) else {
                throw MoyaError.jsonMapping($0)
            }
            if response.success { return response.result }
            throw Network.Error.status(code: response.code, message: response.message)
        }
    }
}

extension OnCache {
    
    public func requestObject() -> Single<C> {
        return target.request().map(Network.Response<C>.self).map({
            if $0.success { return $0.result }
            throw Network.Error.status(code: $0.code, message: $0.message)
        }).storeCachedObject(for: target)
    }
}
