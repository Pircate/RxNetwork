//
//  Observable+Cache.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya

extension ObservableType where E: TargetType, E: Cacheable {
    
    public func request() -> Observable<Moya.Response> {
        return flatMap { target -> Observable<Moya.Response> in
            let source = target.request()
                .storeCachedResponse(for: target)
                .asObservable()
            
            if let response = try? target.cachedResponse(),
                target.allowsStorage(response) {
                return source.startWith(response)
            }
            
            return source
        }
    }
}
