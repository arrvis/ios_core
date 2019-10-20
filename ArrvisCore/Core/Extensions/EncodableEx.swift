//
//  EncodableEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/16.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

extension Encodable {

    /// dictionary
    public var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }

    /// JSON文字列
    public var jsonString: String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(bytes: data, encoding: .utf8)
    }

    /// CSV用
    public var csvJsonString: String? {
        return "\"\(jsonString?.replacingOccurrences(of: "\"", with: "\"\"") ?? "")\""
    }

    /// JS文字列
    func toJsString() -> String? {
        if let dictionary = dictionary {
            let str = dictionary.map { k, v in
                if let v = v as? Encodable {
                    return v.toJsString() ?? "invalid"
                } else if v is String {
                    return "\(k) : \"\(v)\""
                } else {
                    return "\(k) : \(v)"
                }
                }.joined(separator: ", ")
            return "{\(str)}"
        }
        return nil
    }
}
