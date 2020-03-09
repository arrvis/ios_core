//
//  ResponsedNotification.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/01/15.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore

struct ResponsedNotification: BaseModel {
    let id: String
    let type: String
    let attributes: ResponsedNotificationAttributes
    let relationships: NotificationRelationships
}

struct ResponsedNotificationAttributes: BaseModel {
    let id: Int
    let title: String
    let content: String
    let isRequiredRead: Bool
    let isRequiredApproval: Bool
    let approvalConfirmation: String?
    let approvingDeadlineAt: String?
    let publishedAt: String?
    let readerIds: [Int]
    let createdAt: String
    let status: Int
    let target: Int
    let attachments: [ResponsedAttachments]
    let commentedCount: Int
    let notReadersIds: [Int]
    let approvingUserIds: [Int]
    let notApprovingUserIds: [Int]
    let authorDepartmentName: String?

    var publishedAtValue: Date? {
        return publishedAt == nil ? nil : Date.fromString(publishedAt!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")!
    }

    var approvingDeadlineAtValue: Date? {
        return approvingDeadlineAt == nil ? nil : Date.fromString(approvingDeadlineAt!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")!
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case isRequiredRead = "is_required_read"
        case isRequiredApproval = "is_required_approval"
        case approvalConfirmation = "approval_confirmation"
        case approvingDeadlineAt = "approving_deadline_at"
        case publishedAt = "published_at"
        case readerIds = "reader_ids"
        case createdAt = "created_at"
        case status
        case target
        case attachments
        case commentedCount = "commented_count"
        case notReadersIds = "not_readers_ids"
        case approvingUserIds = "approving_user_ids"
        case notApprovingUserIds = "not_approving_user_ids"
        case authorDepartmentName = "author_department_name"
    }
}

struct NotificationRelationships: BaseModel {
    let user: Relationship
    let groups: Relationships
    let notificationComments: Relationships
    enum CodingKeys: String, CodingKey {
        case user
        case groups
        case notificationComments = "notification_comments"
    }
}
