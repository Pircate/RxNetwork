//
//  BannerItemModel.swift
//  LightCloud
//
//  Created by Pircate on 2018/5/29.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Foundation
import CleanJSON

typealias MyCaseDefaultable = CaseDefaultable

enum StoryItemType: Int, Codable, MyCaseDefaultable {
    static var defaultCase: StoryItemType = .east
    
    case sourth = 0
    case east
    case west
    case north
}

struct StoryListModel: Codable {
    let topStories: [StoryItemModel]
    let stories: [StoryItemModel]
    
    enum CodingKeys: String, CodingKey {
        case topStories = "top_stories"
        ,stories
    }
}

struct StoryItemModel: Codable {
    let id: Int
    let title: String
    let image: String
    let type: StoryItemType
    let noKey: Int
}
