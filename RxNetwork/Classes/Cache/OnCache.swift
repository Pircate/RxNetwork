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
    
    public init(_ target: Target) {
        self.target = target
    }
    
    public func request(atKeyPath keyPath: String? = nil,
                        using decoder: JSONDecoder = .init()) -> Single<C> {
        return target.request().map(C.self, atKeyPath: keyPath, using: decoder).storeCachedObject(for: target)
    }
}
