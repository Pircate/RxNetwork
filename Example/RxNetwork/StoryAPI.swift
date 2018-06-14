//
//  BannerAPI.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import Moya

enum StoryAPI {
    case latest
}

extension StoryAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://news-at.zhihu.com/api")!
    }
    
    var path: String {
        switch self {
        case .latest:
            return "4/news/latest"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .latest:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
