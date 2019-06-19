//
//  IntEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/27.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

extension Int {

    /// 文字列化「.」入り
    ///
    /// - Returns: 文字列
    public func toNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value: self))!
    }
}
