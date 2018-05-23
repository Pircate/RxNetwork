//
//  Single+Network.swift
//  RxNetwork
//
//  Created by GorXion on 2018/4/18.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import Moya

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: TargetType {
    
    public func request<T: Codable>(_ type: T.Type,
                                    atKeyPath keyPath: String? = nil,
                                    using decoder: JSONDecoder = .init()) -> Single<T> {
        return flatMap { target -> Single<T> in
            return target.request(type, atKeyPath: keyPath, using: decoder).storeCachedObject(for: target)
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType: Codable {
    
    public func storeCachedObject(for target: TargetType) -> Single<ElementType> {
        return flatMap { object -> Single<ElementType> in
            try? Network.storage?.setObject(object, forKey: target.cachedKey)
            return Single.just(object)
        }
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func mapObject<T: Codable>(_ type: T.Type,
                                      atKeyPath keyPath: String? = nil,
                                      using decoder: JSONDecoder = .init()) -> Single<T> {
        return flatMap { response -> Single<T> in
            do {
                return Single.just(try response.map(type, atKeyPath: keyPath, using: decoder))
            } catch let error {
                if let object = try? decoder.decode(type, from: "{}".data(using: .utf8)!) {
                    return Single.just(object)
                }
                if let object = try? decoder.decode(type, from: "[]".data(using: .utf8)!) {
                    return Single.just(object)
                }
                return Single.error(error)
            }
        }
    }
}
