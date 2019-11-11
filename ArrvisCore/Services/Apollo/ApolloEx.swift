//
//  ApolloEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Apollo

extension GraphQLSelectionSet {

    /// Json文字列に変換
    public func toJsonString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .sortedKeys) {
            return String(bytes: data, encoding: .utf8)
        }
        return nil
    }
}

extension GraphQLError {

    /// エラー文字列に変換
    public func toErrorString() -> String {
        var messages = (self["messages"] as? [String]) ?? []
        if let message = message {
            messages.append(message)
        }
        return messages.joined(separator: ",")
    }
}

extension Date {

    /// Graphqlのレスポンス文字列から変換
    public static func fromGraphqlResponseString(_ dateTimeString: String) -> Date {
        return Date.fromString(dateTimeString, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")!
    }
}

extension BaseModel {

    /// GraphQLSelectionSetから生成
    public static func fromSet(_ set: GraphQLSelectionSet) -> ModelType {
        return fromJson(set.toJsonString()!)
    }
}
