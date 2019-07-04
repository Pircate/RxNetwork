// 
//  Cacheable.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/3/5
//  Copyright © 2019年 Pircate. All rights reserved.
//

import Moya

public typealias Cacheable = Storable & CachingKey & Expirable

public protocol Storable {
    
    /// 是否允许缓存，建议只缓存可以被成功解析的数据
    var allowsStorage: (Moya.Response) -> Bool { get }
    
    /// 获取网络请求的响应数据
    ///
    /// - Parameter key: 缓存的键
    /// - Returns: 网络请求的响应数据
    /// - Throws: 缓存读取可能产生的错误
    func cachedResponse(for key: CachingKey) throws -> Moya.Response
    
    /// 存储网络请求的响应数据
    ///
    /// - Parameters:
    ///   - cachedResponse: 网络请求的响应数据
    ///   - key: 缓存的键
    /// - Throws: 存储缓存可能产生的错误
    func storeCachedResponse(_ cachedResponse: Moya.Response, for key: CachingKey) throws
    
    /// 移除缓存的响应数据
    ///
    /// - Parameter key: 缓存的键
    /// - Throws: 移除缓存可能产生的错误
    func removeCachedResponse(for key: CachingKey) throws
    
    /// 移除所有的缓存数据
    ///
    /// - Throws: 移除缓存可能产生的错误
    func removeAllCachedResponses() throws
}
