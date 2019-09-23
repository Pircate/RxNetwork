//
//  OnCache+Demo.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/7/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import RxSwift
import RxNetwork
import CleanJSON

extension OnCache {
    
    public func requestObject() -> Single<C> {
        return target.request()
            .storeCachedResponse(for: target)
            .map(Network.Response<C>.self, using: CleanJSONDecoder())
            .map {
                if $0.success { return $0.data }
                throw Network.Error.status(code: $0.code, message: $0.message)
            }
    }
}
