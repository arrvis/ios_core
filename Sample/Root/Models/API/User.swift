//
//  User.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct User: BaseModel {
    let id: String
    let type: String
    let attributes: UserAttributes
}

struct UserAttributes: BaseModel {
    let id: Int
    let email: String?
    let phoneNumber: String
    let firstName: String
    let lastName: String
    let gender: Int
    let comment: String?
    let icon: String?
    let totalReceivedClappers: Int
    let presentablePoints: Int
    let useablePoints: Int

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phoneNumber = "phone_number"
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case comment
        case icon
        case totalReceivedClappers = "total_received_clappers"
        case presentablePoints = "presentable_points"
        case useablePoints = "useable_points"
    }

    var fullName: String {
        return "\(lastName) \(firstName)"
    }
}
