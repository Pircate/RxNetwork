//
//  BannerAPI.swift
//  RxNetwork
//
//  Created by GorXion on 2018/4/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Moya

enum BannerAPI {
    case test(count: Int)
}

extension BannerAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://app01.chengtay.com:82/")!
    }
    
    var path: String {
        return "m/banner"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .test(let count):
            return .requestParameters(parameters: ["count": count], encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String: String]? {
        return nil
    }
}
