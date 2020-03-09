//
//  Message.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct Message: BaseModel, Equatable {
    let id: String
    let type: String
    let attributes: MeessageAttribute

    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

    func getDisplayName(_ group: GroupData) -> String {
        if attributes.userId == nil {
            return "削除されたユーザー"
        }
        if let user = group.users.first(where: { Int($0.data.id) == attributes.userId }) {
            return user.data.attributes.fullName
        }
        if attributes.isAdmin {
            return "管理者"
        }
        return "退会済みユーザー"
    }

    func markAsRead(by user: UserData) -> Message {
        var readerIds = attributes.readerIds
        readerIds.append(Int(user.data.id)!)
        return Message(
            id: id,
            type: type,
            attributes: MeessageAttribute(
                id: attributes.id,
                content: attributes.content,
                userId: attributes.userId,
                isAdmin: attributes.isAdmin,
                createdAt: attributes.createdAt,
                readerIds: readerIds,
                clapperIds: attributes.clapperIds,
                stamp: attributes.stamp,
                attachments: attributes.attachments))
    }
}

struct MeessageAttribute: BaseModel {
    let id: Int
    let content: String?
    let userId: Int?
    let isAdmin: Bool
    let createdAt: String
    let readerIds: [Int]
    let clapperIds: [Int]
    let stamp: String?
    let attachments: [ResponsedAttachments]

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case userId = "user_id"
        case isAdmin = "is_admin"
        case createdAt = "created_at"
        case readerIds = "reader_ids"
        case clapperIds = "clapper_ids"
        case stamp
        case attachments
    }

    var createdAtValue: Date {
        return Date.fromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")!
    }
}
