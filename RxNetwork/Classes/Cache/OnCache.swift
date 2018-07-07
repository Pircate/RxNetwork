//
//  OnCache.swift
//  RxNetwork
//
//  Created by Pircate on 2018/6/14.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import RxSwift

public struct OnCache<Target: TargetType, C: Codable> {
    
    public let target: Target
    
    init(_ target: Target) {
        self.target = target
    }
    
    public func request() -> Single<C> {
        return target.request().map(C.self).storeCachedObject(for: target)
    }
}
