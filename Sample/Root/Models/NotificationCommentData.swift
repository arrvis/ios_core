//
//  NotificationCommentData.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/10.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore

struct NotificationCommentData: BaseModel {
    let notificationComment: ResponsedNotificationComment
    let included: [Included]

    var sender: UserData {
        let senderRelationShip = notificationComment.relationships.user
        return UserData(data: UserRelation.fromJson(included.first(where: { $0.type == "user" && $0.id == senderRelationShip.data.id })!.jsonString!), included: included)
    }
}
