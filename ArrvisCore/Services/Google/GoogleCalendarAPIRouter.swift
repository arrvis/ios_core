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

    // MARK: - Variables

    private let baseUrl = "https://www.googleapis.com/calendar/v3"

    // MARK: - Initializer

    init(path: String,
         accessToken: String,
         httpMethod: HTTPMethod = .get,
         parameters: Codable? = nil) {
        super.init(baseURL: baseUrl,
                    path: path,
                    httpMethod: httpMethod,
                    headers: [
                        "Authorization": "Bearer \(accessToken)"
                    ],
                    parameters: parameters)
    }

    // MARK: - Internal

    static func fetchEvents(
        _ calendarId: String,
        _ accessToken: String,
        _ lastSyncTime: Date?,
        _ month: Date?,
        _ disposeBag: DisposeBag,
        _ isDebugEnabled: Bool) -> Observable<[GoogleEvent]> {
        var path = "/calendars/\(calendarId)/events?"
        if let lastSyncTime = lastSyncTime?.plusMinute(-TimeZone.current.secondsFromGMT() / 60) {
            path += "updatedMin=\(lastSyncTime.toGoogleApiFormat())"
        } else if let month = month {
            path += "timeMin=\(month.toGoogleApiFormat())&timeMax=\(month.plusMonth(1).toGoogleApiFormat())"
        }
        if isDebugEnabled {
            print("GoogleService.fetchEventsRequest \(path)")
        }
        let requst: Observable<GoogleEventsResponse> = GoogleCalendarAPIRouter(
            path: path,
            accessToken: accessToken).request()
        return requst.map { $0.items }
    }

    static func fetchCalendarList(_ accessToken: String, _ disposeBag: DisposeBag) -> Observable<[GoogleCalendar]> {
        let request: Observable<GoogleCalendarList> = GoogleCalendarAPIRouter(
            path: "/users/me/calendarList",
            accessToken: accessToken).request()
        return request.map { $0.items }
    }
}

struct GoogleCalendarList: BaseModel {
    public let items: [GoogleCalendar]
}

public struct GoogleCalendar: BaseModel {
    public let id: String
}
