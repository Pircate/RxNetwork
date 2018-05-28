//
//  TestModel.swift
//  RxNetwork
//
//  Created by GorXion on 2018/4/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxNetwork

struct TestModel: Codable {
    let name: String
    let id: String
}

struct TestResponse<T: Codable>: Codable {
    let code: Int
    let message: String
    let result: T
    
    var success: Bool {
        return code == 2000
    }
}

extension Network {
    
    enum Error: Swift.Error {
        case unknown
        case status(message: String)
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: Response {
    
    public func mapResponse<T: Codable>(_ type: T.Type,
                                        atKeyPath keyPath: String? = nil,
                                        using decoder: JSONDecoder = .init()) -> Single<T> {
        return flatMap { response -> Single<T> in
            if let resp = try? response.map(TestResponse<T>.self) {
                if resp.success {
                    return Single.just(resp.result)
                }
                return Single.error(Network.Error.status(message: resp.message))
            }
            return Single.error(MoyaError.jsonMapping(response))
        }
    }
}
