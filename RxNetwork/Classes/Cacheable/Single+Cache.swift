//
//  Single+Cache.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Moya.Response {
    
    public func storeCachedResponse<Target>(for target: Target)
        -> Single<ElementType>
        where Target: TargetType, Target: Cacheable {
        return map { response -> ElementType in
            if target.allowsStorage(response) {
                try? target.storeCachedResponse(response)
            }
            
            return response
        }
    }
}
