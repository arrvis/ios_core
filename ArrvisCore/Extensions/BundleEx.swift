//
//  BundleEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/23.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import Foundation

extension Bundle {

    /// BundleShortVersionString
    public var bundleShortVersionString: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    /// Build
    public var build: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }
}
