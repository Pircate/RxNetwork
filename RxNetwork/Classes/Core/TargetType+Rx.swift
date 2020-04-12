//
//  TargetType+Rx.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/4/17.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import RxSwift
import Moya

public extension TargetType {
    
    func request() -> Single<Moya.Response> {
        return Network.default.provider.rx.request(.target(self))
    }
}
