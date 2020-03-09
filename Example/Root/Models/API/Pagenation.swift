//
//  Pagenation.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct Pagenation: BaseModel {
    let current: Int
    let previous: Int?
    let next: Int?
    let perPage: Int
    let pages: Int
    let count: Int

    enum CodingKeys: String, CodingKey {
        case current
        case previous
        case next
        case perPage = "per_page"
        case pages
        case count
    }
}
