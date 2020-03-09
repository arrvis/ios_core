//
//  HelpData.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/03/04.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore

struct HelpData: BaseModel {
    let help: ResponsedHelp
    let included: [Included]

    var categoryCount: Int {
        return included.filter { $0.type == "help_category" }.count
    }
}
