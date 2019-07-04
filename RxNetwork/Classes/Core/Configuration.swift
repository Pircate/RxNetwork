//
//  Configuration.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/7/7.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya

public extension Network {
    
    class Configuration {
        
        public static var `default`: Configuration = Configuration()
        
        public var addingHeaders: (TargetType) -> [String: String] = { _ in [:] }
        
        public var replacingTask: (TargetType) -> Task = { $0.task }
        
        public var timeoutInterval: TimeInterval = 60
        
        public var plugins: [PluginType] = []
        
        public init() {}
    }
}
