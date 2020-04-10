//
//  BundleEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/23.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

extension Bundle {

    /// BundleShortVersionString
    public var bundleShortVersionString: String {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }

    /// Build
    public var build: String {
        return object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }

    /// BundleName
    public var bundleName: String {
        return object(forInfoDictionaryKey: "CFBundleName") as! String
    }
}
