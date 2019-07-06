//
//  Single+Cache.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    
    public func storeCachedResponse<Target>(for target: Target)
        -> Single<Element>
        where Target: TargetType, Target: Cacheable, Target.ResponseType == Element {
        return map { response -> Element in
            if target.allowsStorage(response) {
                try? target.storeCachedResponse(response)
            }
            
            return response
        }
    }
}
