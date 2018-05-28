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

extension TargetType {
    
    func requestWithResponse<T: Codable>(_ type: T.Type) -> Single<TestResponse<T>> {
        return request(TestResponse<T>.self).flatMap({
            if $0.success {
                return Single.just($0)
            }
            return Single.error(Network.Error.status(message: $0.message))
        })
    }
}
