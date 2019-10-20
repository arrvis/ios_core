//
//  Properties.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// Properties
public protocol Properties {

    var properties: [String: Any?] { get }
}

extension Properties {

    /// プロパティ
    public var properties: [String: Any?] {
        var dic = [String: Any?]()
        Mirror(reflecting: self).superclassMirror?.children.forEach { (child) in
            if let key = child.label {
                dic[key] = child.value
            }
        }
        Mirror(reflecting: self).children.forEach { (child) in
            if let key = child.label {
                dic[key] = child.value
            }
        }
        return dic
    }
}
