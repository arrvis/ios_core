//
//  UserGenre.swift
//  tasuke
//
//  Created by Yutaka Izumaru on 2019/07/19.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import ArrvisCore

/// ユーザージャンル情報
struct UserGenre: BaseModel {
    let genreMaster: GenreMaster
    let customGenre: String?
    let displayValue: String
}
