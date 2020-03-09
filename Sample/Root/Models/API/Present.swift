//
//  Present.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct Present: BaseModel, Equatable {
    let id: String
    let type: String
    let attributes: PresentAttribute
    let relationships: PresentRelationships

    static func == (lhs: Present, rhs: Present) -> Bool {
        return lhs.id == rhs.id
    }

    func addClap(_ clapperId: Int) -> Present {
        return Present(
            id: id,
            type: type,
            attributes: PresentAttribute(
                id: attributes.id,
                comment: attributes.comment,
                pointNumber: attributes.pointNumber,
                createdAt: attributes.createdAt,
                clapperIds: attributes.clapperIds + [clapperId]),
            relationships: relationships)
    }

    func removeClap(_ clapperId: Int) -> Present {
        var tmp = attributes.clapperIds
        tmp.removeAll(where: { $0 == clapperId })
        return Present(
            id: id,
            type: type,
            attributes: PresentAttribute(
                id: attributes.id,
                comment: attributes.comment,
                pointNumber: attributes.pointNumber,
                createdAt: attributes.createdAt,
                clapperIds: tmp),
            relationships: relationships)
    }
}

struct PresentAttribute: BaseModel {
    let id: Int
    let comment: String?
    let pointNumber: Int
    let createdAt: String
    let clapperIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case pointNumber = "point_number"
        case createdAt = "created_at"
        case clapperIds = "clapper_ids"
    }

    var createdAtValue: Date {
        return Date.fromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")!
    }
}

struct PresentRelationships: BaseModel {
    let coin: Relationship
    let from: Relationship
    let to: Relationship
}
