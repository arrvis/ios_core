//
//  GoogleCalendarAPIRouter.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/01/10.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Reachability

/// GoogleAPIルーター
class GoogleCalendarAPIRouter {

    private let baseUrl = "https://www.googleapis.com/calendar/v3/calendars/primary"

    private var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(accessToken)"
        ]
    }

    private let path: String
    private let accessToken: String
    private let httpMethod: HTTPMethod
    private let parameters: Codable?

    /// イニシャライザ
    ///
    /// - Parameters:
    ///   - path: パス
    ///   - accessToken: アクセストークン
    ///   - httpMethod: HTTPメソッド
    ///   - parameters: パラメーター
    init(path: String,
         accessToken: String,
         httpMethod: HTTPMethod = .get,
         parameters: Codable? = nil) {
        self.path = path
        self.accessToken = accessToken
        self.httpMethod = httpMethod
        self.parameters = parameters
    }

    /// リクエスト実行
    ///
    /// - Returns: Observable<T>
    func request<T: Codable>() -> Observable<T> {
        return Observable.create { (observer: AnyObserver) -> Disposable in
            if Reachability()?.connection == .none {
                observer.onError(NoConnectionError())
                return Disposables.create()
            }
            Alamofire.request("\(self.baseUrl)\(self.path)",
                method: .get,
                parameters: self.parameters?.dictionary,
                encoding: JSONEncoding.default,
                headers: self.headers)
                .validate()
                .responseData(completionHandler: { response in
                    // HTTP系エラー
                    guard let data = response.data else {
                        observer.onError(HTTPError(response: response))
                        return
                    }
                    // 成功
                    response.result.ifSuccess {
                        do {
                            let apiResponse = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(apiResponse)
                            observer.onCompleted()
                        } catch let error {
                            observer.onError(error)
                        }
                    }
                })
            return Disposables.create()
        }
    }
}

public struct GoogleEventsResponse: Codable {
    public let items: [GoogleEvent]
}

public struct GoogleEvent: Codable {
    public let id: String
    public let created: String
    public let updated: String
    public let summary: String
    public let start: GoogleDatetime
    public let end: GoogleDatetime
    public let recurringEventId: String?
    public let originalStartTime: GoogleDatetime?
    public let recurrence: [String]?
    public let sequence: Int

    public var updatedAt: Date {
        return Date.fromGoogleApiFormat(updated)
    }
}

public struct GoogleDatetime: Codable {
    public let date: String?
    public let dateTime: String?

    public var d: Date {
        if let date = date {
            return Date.fromGoogleApiDateFormat(date)
        } else {
            return Date.fromGoogleApiFormat(dateTime!)
        }
    }
}

extension Date {

    func toGoogleApiFormat() -> String {
        return self.toString("yyyy-MM-dd'T'HH:mm:ss'Z'")
    }

    static func fromGoogleApiDateFormat(_ value: String) -> Date {
        return Date.fromString(value, format: "yyyy-MM-dd")!
    }

    static func fromGoogleApiFormat(_ value: String) -> Date {
        return Date.fromString(value, format: "yyyy-MM-dd'T'HH:mm:ssZ")
            ?? Date.fromString(value, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
    }
}
