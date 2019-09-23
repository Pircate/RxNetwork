//
//  RxNetwork+Demo.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/7/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Moya
import RxSwift

// MARK: - 不缓存的请求用
public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Single<T> {
        return map { try $0.mapObject(type) }
    }
    
    func mapRawObject<T: Codable>(_ type: T.Type, atKeyPath: String? = nil) -> Single<T> {
        return map { try $0.mapRawObject(type, atKeyPath: atKeyPath) }
    }
}

// MARK: - 需要缓存的请求用
public extension ObservableType where Element == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Observable<T> {
        return map { try $0.mapObject(type) }
    }
    
    func mapRawObject<T: Codable>(_ type: T.Type, atKeyPath: String? = nil) -> Observable<T> {
        return map { try $0.mapRawObject(type, atKeyPath: atKeyPath) }
    }
}
