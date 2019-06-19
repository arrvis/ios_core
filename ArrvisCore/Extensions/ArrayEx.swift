//
//  ArrayEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {

    /// 差分取得
    ///
    /// - Parameter other: 比較対象
    /// - Returns: 差分配列
    public func diff(_ other: [Element]) -> [Element] {
        let all = self + other
        var counter: [Element: Int] = [:]
        all.forEach { counter[$0] = (counter[$0] ?? 0) + 1 }
        return all.filter { (counter[$0] ?? 0) == 1 }
    }

    /// 重複排除取得
    ///
    /// - Parameter other: 比較対象
    /// - Returns: 重複排除後配列
    public func subtracting(_ other: [Element]) -> [Element] {
        return self.compactMap { element in
            if (other.filter { $0 == element }).count == 0 {
                return element
            } else {
                return nil
            }
        }
    }

    /// 重複排除
    ///
    /// - Parameter other: 比較対象
    public mutating func subtract(_ other: [Element]) {
        self = subtracting(other)
    }

    /// チャンク
    ///
    /// - Parameter chunkSize: サイズ
    /// - Returns: チャンク後配列
    public func chunk(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map({ (startIndex) -> [Element] in
            let endIndex = (startIndex.advanced(by: chunkSize) > self.count) ? self.count-startIndex : chunkSize
            return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
        })
    }
}

extension Array where Element: Equatable {

    /// 重複排除
    ///
    /// - Returns: 重複排除後配列
    public func distinct() -> [Element] {
        return reduce([Element]()) { $0.contains($1) ? $0 : $0 + [$1] }
    }
}
