//
//  Footer.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/03/05.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore

struct Footer: BaseModel {
    let notReadMessagesCount: Int
    let notReadNotificationsCount: Int
    let hasNewPresent: Bool

    enum CodingKeys: String, CodingKey {
        case notReadMessagesCount = "not_read_messages_count"
        case notReadNotificationsCount = "not_read_notifications_count"
        case hasNewPresent = "has_new_present"
    }
}
