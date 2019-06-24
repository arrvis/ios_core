//
//  HTTPError.swift
//  Arrvis
//
//  Created by Yutaka Izumaru on 2018/02/23.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Alamofire

/// HTTPエラー
public class HTTPError: Error {

    /// HTTPステータスコード
    public let httpStatusCode: HttpStatusCode?

    /// エラーソース
    public let source: Error?

    /// イニシャライザ
    ///
    /// - Parameters:
    ///   - response: レスポンス
    ///   - source: エラーソース
    init(response: Alamofire.DataResponse<Data>) {
        if let httpStatusCode = response.response?.statusCode {
            self.httpStatusCode = HttpStatusCode(rawValue: httpStatusCode)
        } else {
            self.httpStatusCode = nil
        }
        self.source = response.error
    }
}
