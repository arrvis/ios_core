//
//  ResponsedGroup.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct ResponsedGroup: BaseModel, Equatable {
    let id: String
    let type: String
    let attributes: ResponsedGroupAttribute

    var groupNameLabelText: String {
        return "\(attributes.name) (\(attributes.usersCount.toNumberString()))"
    }

    static func == (lhs: ResponsedGroup, rhs: ResponsedGroup) -> Bool {
        return lhs.id == rhs.id
    }

    func isOwner(_ user: UserData) -> Bool {
        return user.data.id == String(attributes.ownerId)
    }
}

struct ResponsedGroupAttribute: BaseModel {
    let id: Int
    let name: String
    let usersCount: Int
    let ownerId: Int
    let icon: String?
    let latestMessage: LatestMessage?
    let notReadMessagesCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case usersCount = "users_count"
        case ownerId = "owner_id"
        case icon
        case latestMessage = "latest_message"
        case notReadMessagesCount = "not_read_messages_count"
    }
}

struct LatestMessage: BaseModel {
    let id: Int
    let userId: Int
    let groupId: Int
    let content: String?
    let createdAt: String
    let updatedAt: String

    var createdAtValue: Date {
        return Date.fromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")!
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case groupId = "group_id"
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
