//
//  Observable+Network.swift
//  RxNetwork
//
//  Created by GorXion on 2018/4/18.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import Moya
import Result

extension ObservableType where E: TargetType {
    public func request<T: Codable>(_ type: T.Type,
                                    atKeyPath keyPath: String? = nil,
                                    using decoder: JSONDecoder = .init()) -> Observable<T> {
        return flatMap { target -> Observable<T> in
            if let entry = try? Network.storage?.entry(ofType: type, forKey: target.cachedKey), let object = entry?.object {
                return target.request(type, atKeyPath: keyPath, using: decoder).storeCachedObject(for: target).asObservable().startWith(object)
            }
            return target.request(type, atKeyPath: keyPath, using: decoder).storeCachedObject(for: target).asObservable()
        }
    }
}

extension ObservableType where E == Response {
    public func mapObject<T: Codable>(_ type: T.Type,
                                      atKeyPath keyPath: String? = nil,
                                      using decoder: JSONDecoder = .init()) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            do {
                return Observable.just(try response.map(type, atKeyPath: keyPath, using: decoder))
            } catch let error {
                if let object = try? decoder.decode(type, from: "{}".data(using: .utf8)!) {
                    return Observable.just(object)
                }
                if let object = try? decoder.decode(type, from: "[]".data(using: .utf8)!) {
                    return Observable.just(object)
                }
                return Observable.error(error)
            }
        }
    }
    
    public func mapResult<T: Codable>(_ type: T.Type,
                                      atKeyPath keyPath: String? = nil,
                                      using decoder: JSONDecoder = .init()) -> Observable<Result<T, MoyaError>> {
        return flatMap { response -> Observable<Result<T, MoyaError>> in
            do {
                return Observable.just(.success(try response.map(type, atKeyPath: keyPath, using: decoder)))
            } catch let error {
                return Observable.just(.failure(.objectMapping(error, response)))
            }
        }
    }
}
