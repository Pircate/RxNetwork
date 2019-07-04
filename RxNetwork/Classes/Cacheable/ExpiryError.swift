// 
//  ExpiryError.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/4/22
//  Copyright © 2019年 Pircate. All rights reserved.
//

public enum ExpiryError: Swift.Error {
    case noCache
    case expired(Expired)
}

public struct Expired {
    public let date: Date
}
