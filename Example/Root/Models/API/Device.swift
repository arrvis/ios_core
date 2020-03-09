//
//  Device.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct Device: BaseModel {
    let id: String
    let type: String
    let attributes: DeviceAttribute
}

struct DeviceAttribute: BaseModel {
    let id: Int
    let os: Int
    let fcmToken: String

    enum CodingKeys: String, CodingKey {
        case id
        case os
        case fcmToken = "fcm_token"
    }
}
