//
//  BaseModel.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/04/09.
//  Copyright © 2019年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

// Model Protocol
public protocol BaseModel: Codable {
    associatedtype ModelType: Codable = Self
}

extension BaseModel {

    /// Objectから生成
    public static func fromObject(object: Any,
                                  options: JSONSerialization.WritingOptions = .prettyPrinted) -> ModelType {
        return fromJson(json: try! JSONSerialization.data(withJSONObject: object, options: options))
    }

    /// JSON文字列から生成
    public static func fromJson(json: String) -> ModelType {
        return fromJson(json: json.data(using: .utf8)!)
    }

    /// JSONデータから生成
    public static func fromJson(json: Data) -> ModelType {
        return try! JSONDecoder().decode(Self.self, from: json) as! Self.ModelType
    }
}
