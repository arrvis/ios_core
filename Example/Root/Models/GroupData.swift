//
//  GroupData.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct GroupData: BaseModel {
    let group: ResponsedGroup
    let users: [UserData]
    let isJoined: Bool
}
