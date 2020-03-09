//
//  NotificationData.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/01/16.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore

struct NotificationData: BaseModel {
    let notification: ResponsedNotification
    let included: [Included]

    var sender: UserData {
        return UserData(data: UserRelation.fromJson(included.first(where: { $0.type == "user" && $0.id == notification.relationships.user.data.id })!.jsonString!), included: included)
    }
}
