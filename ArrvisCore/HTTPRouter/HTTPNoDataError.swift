//
//  HTTPNoDataError.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/25.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

/// HTTPデータなしエラー
public class HTTPNoDataError: Error {

    /// HTTPステータスコード
    public let httpStatusCode: HttpStatusCode?

    init(_ httpStatusCode: Int?) {
        self.httpStatusCode = httpStatusCode == nil ? nil : HttpStatusCode(rawValue: httpStatusCode!)
    }
}
