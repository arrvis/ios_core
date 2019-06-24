//
//  HTTPFailure.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/25.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

/// HTTP失敗
public class HTTPFailure: Error {

    /// HTTPステータスコード
    public let httpStatusCode: HttpStatusCode?

    /// Data
    public let data: Data

    init(_ httpStatusCode: Int?, _ data: Data) {
        self.httpStatusCode = httpStatusCode == nil ? nil : HttpStatusCode(rawValue: httpStatusCode!)
        self.data = data
    }
}
