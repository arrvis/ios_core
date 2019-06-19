//
//  UITabBarEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/27.
//  Copyright © 2019年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

private var overrideHeightKey = 0

extension UITabBar {

    /// 高さオーバーライド
    public var overrideHeight: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &overrideHeightKey) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &overrideHeightKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    // TODO: こいつだめ
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let overrideHeight = overrideHeight {
            var size = super.sizeThatFits(size)
            size.height = overrideHeight
            return size
        } else {
            return size
        }
    }
}
