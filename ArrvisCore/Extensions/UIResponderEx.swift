//
//  UIResponderEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

private var networkActivityIndicatorCountKey = 0

extension UIResponder {

    private var networkActivityIndicatorCount: Int {
        get {
            return objc_getAssociatedObject(self, &networkActivityIndicatorCountKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &networkActivityIndicatorCountKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.networkActivityIndicatorCount > 0
        }
    }

    /// NetworkActivityIndicator表示
    public func showNetworkActivityIndicator() {
        networkActivityIndicatorCount += 1
    }

    /// NewtworkAcitivtyIndicator非表示
    public func hideNetworkActivityIndicator() {
        if networkActivityIndicatorCount == 0 {
            return
        }
        networkActivityIndicatorCount -= 1
    }
}
