//
//  EventModels.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/26.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

struct GoogleEventsResponse: BaseModel {
    public let items: [GoogleEvent]
}

/// Googleイベント
public struct GoogleEvent: BaseModel {
    public let id: String
    public let created: String?
    public let updated: String?
    public let summary: String?
    public let start: GoogleDatetime?
    public let end: GoogleDatetime?
    public let recurringEventId: String?
    public let originalStartTime: GoogleDatetime?
    public let recurrence: [String]?
    public let sequence: Int?
    public let description: String?
    public let status: String

    public var updatedAt: Date? {
        if let updated = updated {
            return Date.fromGoogleApiFormat(updated)
        } else {
            return nil
        }
    }
}

/// GoogleDateTime
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
        return self.toString("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }

    static func fromGoogleApiDateFormat(_ value: String) -> Date {
        return Date.fromString(value, format: "yyyy-MM-dd")!
    }

    static func fromGoogleApiFormat(_ value: String) -> Date {
        return Date.fromString(value, format: "yyyy-MM-dd'T'HH:mm:ssZ")
            ?? Date.fromString(value, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
    }
}
