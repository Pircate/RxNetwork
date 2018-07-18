//
//  Response+Demo.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/7/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Moya
import RxNetwork

public extension Response {
    
    func mapObject<T: Codable>(_ type: T.Type) throws -> T {
        let response = try map(Network.Response<T>.self)
        if response.success { return response.data }
        throw Network.Error.status(code: response.code, message: response.message)
    }
    
    func mapCode() throws -> Int {
        return try map(Int.self, atKeyPath: "code")
    }
    
    func mapMessage() throws -> String {
        return try map(String.self, atKeyPath: "message")
    }
}

