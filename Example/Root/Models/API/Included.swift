//
//  Included.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/12/05.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import AnyCodable

struct Included: BaseModel {
    let id: String
    let type: String
    let attributes: [String: AnyCodable]
    let relationships: [String: AnyCodable]?
}
