//
//  KeyedDecodingContainer+TypeConversion.swift
//  Network
//
//  Created by GorXion on 2018/4/18.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    public func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let intValue = try? decode(Int.self, forKey: key){
            return String(intValue)
        }
        if let doubleValue = try? decode(Double.self, forKey: key) {
            return String(doubleValue)
        }
        if let floatValue = try? decode(Float.self, forKey: key) {
            return String(floatValue)
        }
        return nil
    }
    
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        return try? decode(type, forKey: key)
    }
}
