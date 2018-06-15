//
//  Observable+Network.swift
//  RxNetwork
//
//  Created by Pircate on 2018/4/18.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya

extension ObservableType where E: TargetType {
    
    public func request() -> Observable<Response> {
        return flatMap { target -> Observable<Response> in
            let source = target.request().storeCachedResponse(for: target).asObservable()
            if let response = target.cachedResponse,
                let object = try? response.mapJSON(),
                JSONSerialization.isValidJSONObject(object) {
                return source.startWith(response)
            }
            return source
        }
    }
}
