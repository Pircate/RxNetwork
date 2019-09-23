//
//  Network+Rx.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/5/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import RxNetwork

extension Network {
    
    struct Response<T: Codable>: Codable {
        let code: Int
        let message: String
        let data: T
        
        var success: Bool {
            return code == 2000
        }
        
        enum CodingKeys: String, CodingKey {
            case code
            case message
            case data = "result"
        }
    }
}

extension Network {
    
    enum Error: Swift.Error {
        case status(code: Int, message: String)
        
        var code: Int {
            switch self {
            case .status(let code, _):
                return code
            }
        }
        
        var message: String {
            switch self {
            case .status(_, let message):
                return message
            }
        }
    }
}
