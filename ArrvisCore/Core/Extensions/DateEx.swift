//
//  DateEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

extension Date {

    // MARK: - Const

    /// 曜日
    ///
    /// - Sun: 日曜
    /// - Mon: 月曜
    /// - Tue: 火曜
    /// - Wed: 水曜
    /// - Thu: 木曜
    /// - Fri: 金曜
    /// - Sat: 土曜
    public enum Weekday: Int, CaseIterable, Codable {
        case sun = 1
        case mon = 2
        case tue = 3
        case wed = 4
        case thu = 5
        case fri = 6
        case sat = 7
    }

    // MARK: - Variables

    /// 週あたりの日数
    public static var daysPerWeek: Int {
        return 7
    }

    /// デフォルトカレンダー
    public static var defaultCalendar: Calendar {
        return Calendar(identifier: .gregorian)
    }

    /// 現在
    public static var now: Date {
        let components = defaultCalendar.dateComponents(
            [
                .year,
                .month,
                .day,
                .hour,
                .minute,
                .second,
                .nanosecond
            ],
            from: Date())
        return defaultCalendar.date(from: components)!
    }

    /// 本日
    public static var today: Date {
        return Date.now.startOfDay
    }

    /// DateComponents
    public var dateComponents: DateComponents {
        return Date.defaultCalendar.dateComponents(in: .current, from: self)
    }

    /// 月の初めの日
    public var firstDateOfMonth: Date {
        var components = Date.defaultCalendar.dateComponents([.year, .month, .day], from: self)
        components.day = 1
        return Date.defaultCalendar.date(from: components)!
    }

    /// 週の初めの日（日曜開始）
    public var firstDateOfWeekFromSunday: Date {
        for weekday in Date.Weekday.sun.rawValue...Date.Weekday.sat.rawValue {
            let day = self.plusDay(-weekday + 1)
            if day.weekday == Weekday.sun {
                return Date.defaultCalendar.date(from: Date.defaultCalendar.dateComponents(
                    [
                        .year,
                        .month,
                        .day
                    ],
                    from: day))!
            }
        }
        return Date.today
    }

    /// 月の週数
    public var numberOfWeeksForMonth: Int {
        return (Date.defaultCalendar.range(of: Calendar.Component.weekOfMonth,
                                           in: Calendar.Component.month,
                                           for: firstDateOfMonth)?.count)!
    }

    /// 月の日数
    public var numberOfDaysForMonth: Int {
        let rangeOfDays = Date.defaultCalendar.range(of: Calendar.Component.day,
                                                     in: Calendar.Component.month,
                                                     for: firstDateOfMonth)
        return (rangeOfDays?.count)!
    }

    /// 第X週
    public var weekdayOrdinal: Int {
        let components = Date.defaultCalendar.dateComponents([.year, .month, .day, .weekdayOrdinal], from: self)
        return components.weekdayOrdinal!
    }

    /// 曜日
    public var weekday: Date.Weekday {
        return Weekday(rawValue: Date.defaultCalendar.component(.weekday, from: self))!
    }

    /// 指定された日の00:00:00
    public var startOfDay: Date {
        let components = Date.defaultCalendar.dateComponents([.year, .month, .day], from: self)
        return Date.defaultCalendar.date(from: components)!
    }

    /// 指定された日時間の23:59:59
    public var endOfDay: Date {
        return self.startOfDay.plusDay(1).plusSeconds(-1)
    }
}

// MARK: - func
extension Date {

    /// 年を加算
    ///
    /// - Parameter year: 年
    /// - Returns: 加算後のDate
    public func plusYear(_ year: Int) -> Date {
        return Date.defaultCalendar.date(byAdding: .year, value: year, to: self)!
    }

    /// 月を加算
    ///
    /// - Parameter month: 月
    /// - Returns: 加算後のDate
    public func plusMonth(_ month: Int) -> Date {
        return Date.defaultCalendar.date(byAdding: .month, value: month, to: self)!
    }

    /// 日を加算
    ///
    /// - Parameter day: 日
    /// - Returns: 加算後のDate
    public func plusDay(_ day: Int) -> Date {
        return Date.defaultCalendar.date(byAdding: .day, value: day, to: self)!
    }

    /// 時間を加算
    ///
    /// - Parameter hour: 時間
    /// - Returns: 加算後のDate
    public func plusHour(_ hour: Int) -> Date {
        return Date.defaultCalendar.date(byAdding: .hour, value: hour, to: self)!
    }

    /// 分を加算
    ///
    /// - Parameter minute: 分
    /// - Returns: 加算後のDate
    public func plusMinute(_ minute: Int) -> Date {
        return Date.defaultCalendar.date(byAdding: .minute, value: minute, to: self)!
    }

    /// 秒を加算
    ///
    /// - Parameter second: 秒
    /// - Returns: 加算後のDate
    public func plusSeconds(_ second: Int) -> Date {
        return Date.defaultCalendar.date(byAdding: .second, value: second, to: self)!
    }

    /// 日が重なっているかどうか
    ///
    /// - Parameters:
    ///   - otherRange: 判定対象
    /// - Returns: 日が重なっているかどうか
    public func isOverlapDay(_ otherRange: (Date, Date)) -> Bool {
        return Date.isOverlapDay((self.startOfDay, self.endOfDay), otherRange)
    }

    /// toString()
    ///
    /// - Parameter format: フォーマット
    /// - Parameter calendarIdntifier: カレンダーIdentifier
    /// - Returns: 文字列
    public func toString(
        _ format: String,
        calendarIdentifier: Calendar.Identifier = .gregorian,
        locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: calendarIdentifier)
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: self)
    }
}

extension Date.Weekday {

    /// 短い日本語文字列に変換
    public func toShortJapaneseString() -> String {
        switch self {
        case .sun:
            return "日"
        case .mon:
            return "月"
        case .tue:
            return "火"
        case .wed:
            return "水"
        case .thu:
            return "木"
        case .fri:
            return "金"
        case .sat:
            return "土"
        }
    }
}
