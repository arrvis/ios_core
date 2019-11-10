//
//  BaseHTTPRouter.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/13.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Alamofire
import RxSwift
import Reachability

/// HTTPルーター基底クラス
open class BaseHTTPRouter {

    // MARK: - Variables

    /// デバッグが有効か
    open var debugEnabled: Bool {
        return false
    }

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
    public func request<T: Codable>() -> Observable<T> {
        return requestData().map { try! JSONDecoder().decode(T.self, from: $0.0) }
    }

    /// リクエスト実行
    public func requestWithResponseHeaders<T: Codable>() -> Observable<(T, [AnyHashable: Any])> {
        return requestData().map { (try! JSONDecoder().decode(T.self, from: $0.0), $0.1) }
    }

    /// リクエスト実行
    public func requestData() -> Observable<(Data, [AnyHashable: Any])> {
        return Observable.create { observer in
            DispatchQueue.main.async {
                NetworkUtil.showNetworkActivityIndicator()
            }
            if Reachability()?.connection == Reachability.Connection.none {
                observer.onError(NoConnectionError())
                return Disposables.create()
            }
            let url = "\(self.baseURL)\(self.path)"
            Alamofire.request(url,
                              method: self.httpMethod,
                              parameters: self.parameters?.dictionary,
                              encoding: JSONEncoding.default,
                              headers: self.headers)
                .validate()
                .responseData(completionHandler: { response in
                    if self.debugEnabled {
                        let data = response.data == nil ? "no data" : String(bytes: response.data!, encoding: .utf8)!
                        print("[\(self.httpMethod.rawValue)] \(url)\n\(data)")
                    }
                    DispatchQueue.main.async {
                        NetworkUtil.hideNetworkActivityIndicator()
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
                    if let error = response.error {
                        observer.onError(HTTPError(response.response?.statusCode, error))
                        return
                    }
                    observer.onNext((data, res.allHeaderFields))
                    observer.onCompleted()
                })
            return Disposables.create()
        }
    }
}
