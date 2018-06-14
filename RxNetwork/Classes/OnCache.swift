//
//  OnCache.swift
//  RxNetwork
//
//  Created by GorXion on 2018/6/14.
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
