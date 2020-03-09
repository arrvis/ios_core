//
//  UserRelations.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct UserRelation: BaseModel, Equatable {
    let id: String
    let type: String
    let attributes: UserAttributes
    let relationships: UserRelationRelationships

    static func == (lhs: UserRelation, rhs: UserRelation) -> Bool {
        return lhs.id == rhs.id
    }
}

struct UserRelationRelationships: BaseModel {
    let role: Relationship
    let department: Relationship
    let devices: Relationships
}
