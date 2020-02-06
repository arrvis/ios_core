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

    /// ヘッダー
    open var headers: HTTPHeaders? {
        return nil
    }

    private let baseURL: String
    private let path: String
    private let httpMethod: HTTPMethod
    private let parameters: Codable?

    // MARK: - Initializer

    public init(baseURL: String,
                path: String,
                httpMethod: HTTPMethod = .get,
                parameters: Codable? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
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
        return Observable.create { [unowned self] observer in
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
                .responseData(completionHandler: { [unowned self] response in
                    if self.debugEnabled {
                        var params = self.parameters?.jsonString ?? "no param"
                        if params.count > 1024 {
                            let paramsCount = max(params.count / 2, 1024 / 2)
                            params = params.prefix(paramsCount) + "..." + params.suffix(paramsCount)
                        }
                        var data = response.data == nil ? "no data" : String(bytes: response.data!, encoding: .utf8)!
                        if data.count > 1024 {
                            let dataCount = max(data.count / 2, 1024 / 2)
                            data = data.prefix(dataCount) + "..." + data.suffix(dataCount)
                        }
                        let urlInfo = "[\(self.httpMethod.rawValue)] \(url)"
                        print("\(urlInfo)\n\(params)\n\(data)")
                    }
                    DispatchQueue.main.async {
                        NetworkUtil.hideNetworkActivityIndicator()
                    }
                    let httpError = HTTPError(
                        response.response?.statusCode,
                        response.response,
                        response.data,
                        response.error
                    )
                    guard let data = response.data else {
                        observer.onError(httpError)
                        return
                    }
                    guard let res = response.response else {
                        observer.onError(httpError)
                        return
                    }
                    response.result.ifFailure {
                        observer.onError(httpError)
                        return
                    }
                    observer.onNext((data, res.allHeaderFields))
                    observer.onCompleted()
                })
            return Disposables.create()
        }
    }
}
