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
        return requestData().map { try! JSONDecoder().decode(T.self, from: $0.0) }
    }

    /// リクエスト実行
    public func requestCodableWithResponseHeaders<T: Codable>() -> Observable<(T, [AnyHashable: Any])> {
        return requestData().map { (try! JSONDecoder().decode(T.self, from: $0.0), $0.1) }
    }

    /// リクエスト実行
    public func requestModel<T: BaseModel>() -> Observable<T> {
        return requestData().map { T.fromJson(json: $0.0) as! T }
    }

    /// リクエスト実行
    public func requestModelWithResponseHeaders<T: BaseModel>() -> Observable<(T, [AnyHashable: Any])> {
        return requestData().map { (T.fromJson(json: $0.0) as! T, $0.1) }
    }

    /// リクエスト実行
    public func requestData() -> Observable<(Data, [AnyHashable: Any])> {
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
                    guard let res = response.response else {
                        observer.onError(HTTPNoDataError(response.response?.statusCode))
                        return
                    }
                    guard let data = response.data else {
                        observer.onError(HTTPNoDataError(response.response?.statusCode))
                        return
                    }
                    response.result.ifFailure {
                        observer.onError(HTTPFailure(response.response?.statusCode, data))
                        return
                    }
                    observer.onNext((data, res.allHeaderFields))
                })
            return Disposables.create()
        }
    }
}
