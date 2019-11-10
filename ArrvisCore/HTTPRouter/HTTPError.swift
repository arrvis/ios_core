//
//  HTTPError.swift
//  Arrvis
//
//  Created by Yutaka Izumaru on 2018/02/23.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// HTTPエラー
public class HTTPError: Error {

    /// HTTPステータスコード
    public let httpStatusCode: HttpStatusCode?

    /// エラーソース
    public let error: Error

    init(_ httpStatusCode: Int?, _ error: Error) {
        self.httpStatusCode = httpStatusCode == nil ? nil : HttpStatusCode(rawValue: httpStatusCode!)
        self.error = error
    }
}
