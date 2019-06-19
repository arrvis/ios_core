//
//  StringEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/14.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

extension String {

    /// スネークケースに変換
    public func toSnakenized() -> String {
        // Ensure the first letter is capital
        let head = String(prefix(1))
        let tail = String(suffix(count - 1))
        let upperCased = head + tail

        let input = upperCased

        // split input string into words with Capital letter
        let pattern = "[A-Z]+[a-z,\\d]*"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return ""
        }

        var words: [String] = []

        regex.matches(in: input, options: [], range: NSRange(location: 0, length: count)).forEach { match in
            if let range = Range(match.range(at: 0), in: self) {
                words.append(String(self[range]).lowercased())
            }
        }

        return words.joined(separator: "_")
    }

    /// キャメルケースに変換
    ///
    /// - Parameter lower: true:lower false:upper
    /// - Returns: 変換後
    public func camelized(lower: Bool = true) -> String {
        let words = lowercased().split(separator: "_").map({ String($0) })
        let firstWord: String = words.first ?? ""

        let camel: String = lower
            ? firstWord
            : "\(firstWord.prefix(1).capitalized)\(firstWord.suffix(from: index(after: startIndex)))"
        return words.dropFirst().reduce(into: camel, { camel, word in
            camel.append(String(word.prefix(1).capitalized) + String(word.suffix(from: index(after: startIndex))))
        })
    }

    /// URLエンコード済みStringに変換
    public func toUrlEncodedString() -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}
