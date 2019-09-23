//
//  BannerModel.swift
//  RxNetwork
//
//  Created by Pircate on 2018/4/17.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Foundation

enum StoryType: Int, Codable, MyCaseDefaultable {    
    static var defaultCase: StoryType = .east
    
    case east = 0
    case sourth
    case west
    case north
}

struct BannerModel: Codable {
    let name: String
    let id: Int
    let noKey: Int
}
