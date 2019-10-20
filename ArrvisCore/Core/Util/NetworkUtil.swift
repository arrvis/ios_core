//
//  NetworkUtil.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/25.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

private var networkActivityIndicatorCountKey = 0

/// ネットワークユーティリティ
public final class NetworkUtil {

    private static var networkActivityIndicatorCount: Int {
        get {
            return objc_getAssociatedObject(self, &networkActivityIndicatorCountKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &networkActivityIndicatorCountKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.networkActivityIndicatorCount > 0
        }
    }

    /// NetworkActivityIndicator表示
    public static func showNetworkActivityIndicator() {
        networkActivityIndicatorCount += 1
    }

    /// NewtworkAcitivtyIndicator非表示
    public static func hideNetworkActivityIndicator() {
        if networkActivityIndicatorCount == 0 {
            return
        }
        networkActivityIndicatorCount -= 1
    }
}
