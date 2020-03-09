//
//  ResponsedDepartment.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct ResponsedDepartment: BaseModel {
    let id: String
    let type: String
    let attributes: ResponsedDepartmentAttribute
}

struct ResponsedDepartmentAttribute: BaseModel {
    let id: Int
    let name: String
}
