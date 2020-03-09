//
//  Coin.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct Coin: BaseModel, Equatable {
    let id: String
    let type: String
    let attributes: CoinAttribute

    static func == (lhs: Coin, rhs: Coin) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CoinAttribute: BaseModel {
    let id: Int
    let name: String
    let defaultPointNumber: Int
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case defaultPointNumber = "default_point_number"
        case icon
    }
}
