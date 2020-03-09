//
//  Group.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct Group: BaseModel {
    let group: GroupObject
}

struct GroupObject: BaseModel {
    let name: String
    let userIds: [Int]

    enum CodingKeys: String, CodingKey {
        case name
        case userIds = "user_ids"
    }
}
