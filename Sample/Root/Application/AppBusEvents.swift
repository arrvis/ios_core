//
//  AppBusEvents.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import ArrvisCore

/// アプリBusEvent
enum AppBusEvents: String, BusEvents {
    case hoge

    var name: String {
        return rawValue
    }
}
