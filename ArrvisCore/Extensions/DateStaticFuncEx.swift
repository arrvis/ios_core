//
//  DateStaticFuncEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

extension Date {

    /// 時間
    public static func getTime(_ hour: Int, _ minutes: Int) -> Date {
        let components = defaultCalendar.dateComponents(
            [.hour, .minute],
            from: Date(timeIntervalSince1970: TimeInterval((hour * 60 + minutes) * 60)))
        return defaultCalendar.date(from: components)!
    }

    /// 指定された日時の間の日を配列で取得
    ///
    /// - Parameters:
    ///   - start: 開始
    ///   - end: 終了
    /// - Returns: [Date]
    public static func getDays(start: Date, end: Date) -> [Date] {
        var ret = [Date]()
        var s = start.startOfDay
        let e = end.startOfDay

        ret.append(s)
        while !defaultCalendar.isDate(s, inSameDayAs: e) {
            s = s.plusDay(1)
            ret.append(s)
        }
        ret.append(e)

        return ret
    }

    /// 指定された日時の間の月を配列で取得
    ///
    /// - Parameters:
    ///   - start: 開始
    ///   - end: 終了
    /// - Returns: [Date]
    public static func getMonths(start: Date, end: Date) -> [Date] {
        var ret = [Date]()
        var s = start.startOfDay
        let e = end.startOfDay

        ret.append(s)
        while !defaultCalendar.isDate(s, inSameDayAs: e) {
            s = s.plusMonth(1)
            ret.append(s)
        }
        ret.append(e)

        return ret
    }

    /// 指定された日時の間の時間を配列で取得
    ///
    /// - Parameters:
    ///   - start: 開始
    ///   - end: 終了
    /// - Returns: [Date]
    public static func getMinutes(start: Date, end: Date) -> [Date] {
        var ret = [Date]()
        var s = start.startOfDay
        let e = end.startOfDay

        ret.append(s)
        while !defaultCalendar.isDate(s, inSameDayAs: e) {
            s = s.plusMinute(1)
            ret.append(s)
        }
        ret.append(e)

        return ret
    }

    /// 同じ日かどうか
    ///
    /// - Parameters:
    ///   - d1: 日付1
    ///   - d2: 日付2
    /// - Returns: 同じ日かどうか
    public static func isEqualDay(_ left: Date, _ right: Date) -> Bool {
        return defaultCalendar.isDate(left, inSameDayAs: right)
    }

    /// 指定された分間隔でroundFloor
    ///
    /// - Parameters:
    ///   - from: 元
    ///   - intervalMinutes: 間隔
    /// - Returns: Date
    public static func roundFloorInterval(_ from: Date, intervalMinutes: Int) -> Date {
        var components = defaultCalendar.dateComponents([.year, .month, .day, .hour, .minute],
                                                        from: from)
        components.minute = components.minute! - components.minute! % intervalMinutes
        return defaultCalendar.date(from: components)!
    }

    /// 指定された分間隔でroundCeiling
    ///
    /// - Parameters:
    ///   - from: 元
    ///   - intervalMinutes: 間隔
    /// - Returns: Date
    public static func roundCeilingInterval(_ from: Date, intervalMinutes: Int) -> Date {
        let components = defaultCalendar.dateComponents([.year, .month, .day, .hour, .minute],
                                                        from: from)
        let mod = components.minute! % intervalMinutes
        return mod == 0
            ? roundFloorInterval(from, intervalMinutes: intervalMinutes)
            : roundFloorInterval(from, intervalMinutes: intervalMinutes).plusMinute(intervalMinutes)
    }

    /// fromString()
    ///
    /// - Parameters:
    ///   - string: 文字列
    ///   - format: フォーマット
    /// - Parameter calendarIdntifier: カレンダーIdentifier
    /// - Returns: Date
    public static func fromString(_ string: String,
                                  format: String,
                                  calendarIdentifier: Calendar.Identifier = .gregorian) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: calendarIdentifier)
        formatter.dateFormat = format
        return formatter.date(from: string)
    }

    /// 日が重なっているかどうか
    ///
    /// - Parameters:
    ///   - baseRange: ベース範囲
    ///   - otherRange: 判定対象
    /// - Returns: 日が重なっているかどうか
    public static func isOverlapDay(_ baseRange: (Date, Date), _ otherRange: (Date, Date)) -> Bool {
        // 開始がbaseの範囲内にいたら重なってる
        if baseRange.0 <= otherRange.0 && otherRange.0 <= baseRange.1 {
            return true
        }
        // 終了がbaseの範囲内にいたら重なってる
        if baseRange.0 <= otherRange.1 && otherRange.1 <= baseRange.1 {
            return true
        }
        // otherがbaseを内包していたら重なってる
        if otherRange.0 <= baseRange.0 && baseRange.1 <= otherRange.1 {
            return true
        }
        return false
    }
}
