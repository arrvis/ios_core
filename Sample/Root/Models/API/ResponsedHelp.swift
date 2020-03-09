//
//  ResponsedHelp.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/03/04.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore

struct ResponsedHelp: BaseModel {
    let id: String
    let type: String
    let attributes: HelpAttributes
    let relationships: HelpRelationships
}

struct HelpAttributes: BaseModel {
    let id: Int
    let question: String
    let answer: String
    let createdAt: String
    let helpCategoryId: Int
    let categoryName: String

    enum CodingKeys: String, CodingKey {
        case id
        case question
        case answer
        case createdAt = "created_at"
        case helpCategoryId = "help_category_id"
        case categoryName = "category_name"
    }
}

struct HelpRelationships: BaseModel {
    let helpCategory: Relationship

    enum CodingKeys: String, CodingKey {
        case helpCategory = "help_category"
    }
}
