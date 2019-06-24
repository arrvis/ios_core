//
//  BaseHTTPRouter.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/13.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Reachability

/// HTTPルーター基底クラス
open class BaseHTTPRouter {

    // MARK: - Variables

    private let baseURL: String
    private let path: String
    private let httpMethod: HTTPMethod
    private let headers: HTTPHeaders?
    private let parameters: Codable?

    // MARK: - Initializer

    public init(baseURL: String,
                path: String,
                httpMethod: HTTPMethod = .get,
                headers: HTTPHeaders? = nil,
                parameters: Codable? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
    }

    /// リクエスト実行
    public func requestCodable<T: Codable>() -> Observable<T> {
        return requestDatResponse().map { try! JSONDecoder().decode(T.self, from: $0.data!) }
    }

    /// リクエスト実行
    public func requestModel<T: BaseModel>() -> Observable<T> {
        return requestDatResponse().map { T.fromJson(json: $0.data!) as! T }
    }

    /// リクエスト実行
    public func requestDatResponse() -> Observable<DataResponse<Data>> {
        return Observable.create { observer in
            if Reachability()?.connection == .none {
                observer.onError(NoConnectionError())
                return Disposables.create()
            }
            Alamofire.request("\(self.baseURL)\(self.path)",
                method: self.httpMethod,
                parameters: self.parameters?.dictionary,
                encoding: JSONEncoding.default,
                headers: self.headers).validate().responseData(completionHandler: { response in
                    if let error = response.error {
                        observer.onError(HTTPError(response.response?.statusCode, error))
                        return
                    }
                    observer.onNext(response)
                })
            return Disposables.create()
        }
    }
}
