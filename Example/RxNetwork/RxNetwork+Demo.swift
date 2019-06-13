//
//  RxNetwork+Demo.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/7/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Moya
import RxSwift

public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Single<T> {
        return map { try $0.mapObject(type) }
    }
}

public extension ObservableType where Element == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Observable<T> {
        return map { try $0.mapObject(type) }
    }
}
