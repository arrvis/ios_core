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
class GoogleCalendarAPIRouter: BaseHTTPRouter {

    private let baseUrl = "https://www.googleapis.com/calendar/v3/calendars"

    init(calendarId: String,
         path: String,
         accessToken: String,
         httpMethod: HTTPMethod = .get,
         parameters: Codable? = nil) {
        super.init(baseURL: "\(baseUrl)/\(calendarId)",
                    path: path,
                    httpMethod: httpMethod,
                    headers: [
                        "Authorization": "Bearer \(accessToken)"
                    ],
                    parameters: parameters)
    }

    static func fetchEvents(_ calendarId: String,
                            _ accessToken: String,
                            _ lastSyncTime: Date?,
                            _ month: Date?,
                            _ disposeBag: DisposeBag) -> Observable<GoogleEventsResponse> {
        var path = "/events?"
        if let lastSyncTime = lastSyncTime?.plusMinute(TimeZone.current.secondsFromGMT() / 60) {
            path += "updatedMin=\(lastSyncTime.toGoogleApiFormat())"
        } else if let month = month {
            path += "timeMin=\(month.toGoogleApiFormat())&timeMax=\(month.plusMonth(1).toGoogleApiFormat())"
        }
        return GoogleCalendarAPIRouter(calendarId: calendarId,
                                       path: path,
                                       accessToken: accessToken).request()
    }
}

public struct GoogleEventsResponse: BaseModel {
    public let items: [GoogleEvent]
}

public struct GoogleEvent: BaseModel {
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

public struct GoogleDatetime: BaseModel {
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
