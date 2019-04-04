//
//  NetworkIndicatorPlugin.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/4/17.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import Result

public final class NetworkIndicatorPlugin: PluginType {
    
    private static var numberOfRequests: Int = 0 {
        didSet {
            if numberOfRequests > 1 { return }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.numberOfRequests > 0
            }
        }
    }
    
    public init() {}
    
    public func willSend(_ request: RequestType, target: TargetType) {
        NetworkIndicatorPlugin.numberOfRequests += 1
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        NetworkIndicatorPlugin.numberOfRequests -= 1
    }
}

