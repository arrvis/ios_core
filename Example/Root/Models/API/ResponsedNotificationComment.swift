//
//  ResponsedNotificationComment.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/08.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore

struct ResponsedNotificationComment: BaseModel {
    let id: String
    let type: String
    let attributes: ResponsedNotificationCommentAttributes
    let relationships: NotificationCommentRelationships
}

struct ResponsedNotificationCommentAttributes: BaseModel {
    let id: Int
    let content: String?
    let clapperIds: [Int]
    let isAdmin: Bool
    let stamp: String?
    let createdAt: String
    let attachments: [NotificationCommentAttachment]

    var createdAtValue: Date {
        return Date.fromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")!
    }

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case clapperIds = "clapper_ids"
        case isAdmin = "is_admin"
        case stamp
        case createdAt = "created_at"
        case attachments
    }
}

struct NotificationCommentAttachment: BaseModel {
    let id: Int
    let name: String
    let url: String?
}

struct NotificationCommentRelationships: BaseModel {
    let user: Relationship
    let notification: Relationship
}
