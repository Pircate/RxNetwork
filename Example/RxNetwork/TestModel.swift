//
//  TestModel.swift
//  RxNetwork
//
//  Created by GorXion on 2018/4/17.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Foundation

struct TestModel: Codable {
    let name: String?
    let id: String?
}

struct TestResponse<T: Codable>: Codable {
    let statusCode: Int?
    let message: String?
    let data: T?
    
    var success: Bool {
        return statusCode == 200
    }
}
