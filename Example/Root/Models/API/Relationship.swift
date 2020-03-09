//
//  Relationship.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct Relationship: BaseModel {
    let data: RelationshipData
}

struct RelationshipData: BaseModel {
    let id: String
    let type: String
}
