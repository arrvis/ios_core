//
//  UserData.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct UserData: BaseModel, Equatable {
    let data: UserRelation
    let included: [Included]

    var department: DepartmentAttributes {
        return DepartmentAttributes.fromJson(included.first(where: { $0.type == "department" && $0.id == data.relationships.department.data.id })!.attributes.jsonString!)
    }

    var role: RoleAttributes {
        return RoleAttributes.fromJson(included.first(where: { $0.type == "role" && $0.id == data.relationships.role.data.id })!.attributes.jsonString!)
    }

    var title: String {
        return "\(department.name) \(role.name ?? "")"
    }

    static func == (lhs: UserData, rhs: UserData) -> Bool {
        return lhs.data == rhs.data
    }

    func isHit(_ searchWord: String) -> Bool {
        return data.attributes.fullName.contains(searchWord) || department.name.contains(searchWord)
    }
}

struct DepartmentAttributes: BaseModel {
    let id: Int
    let name: String
}

struct RoleAttributes: BaseModel {
    let id: Int
    let name: String?
    let groupCreatableNumber: Int?
    let coinSendablePerMonthNumber: Int
    let groupMembersMinNumber: Int?
    let isAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case groupCreatableNumber = "group_creatable_number"
        case coinSendablePerMonthNumber = "coin_sendable_per_month_number"
        case groupMembersMinNumber = "group_members_min_number"
        case isAdmin = "is_admin"
    }
}
