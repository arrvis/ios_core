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

    /// レスポンス
    public let response: HTTPURLResponse?

    /// データ
    public let data: Data?

    /// エラーソース
    public let error: Error?

    init(_ httpStatusCode: Int?, _ response: HTTPURLResponse?, _ data: Data?, _ error: Error?) {
        self.httpStatusCode = httpStatusCode == nil ? nil : HttpStatusCode(rawValue: httpStatusCode!)
        self.response = response
        self.data = data
        self.error = error
    }
}
