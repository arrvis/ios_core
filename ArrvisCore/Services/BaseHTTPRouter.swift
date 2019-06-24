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

    private let baseURL: String
    private let path: String
    private let httpMethod: HTTPMethod
    private let headers: HTTPHeaders?
    private let parameters: Codable?

    /// イニシャライザ
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
    public func requestData() -> Observable<Result<Data>> {
        return request({ response -> Result<Data> in
            return response.result
        })
    }

    /// リクエスト実行
    public func request<T: Codable>() -> Observable<T> {
        return request({ response -> T in
            return try! JSONDecoder().decode(T.self, from: response.data!)
        })
    }

    /// リクエスト実行
    public func request<T: BaseModel>() -> Observable<T> {
        return request({ response -> T in
            return T.fromJson(json: response.data!) as! T
        })
    }

    func request<T: Any>(_ parse: @escaping (DataResponse<Data>) -> T) -> Observable<T> {
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
                    observer.onNext(parse(response))
                })
            return Disposables.create()
        }
    }
}
