//
//  DepartmentData.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

struct DepartmentData: BaseModel {
    let department: ResponsedDepartment
    let users: [UserData]
}
