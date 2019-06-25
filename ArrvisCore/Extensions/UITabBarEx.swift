////
////  HeightChangeableTabBar.swift
////  ArrvisCore
////
////  Created by Yutaka Izumaru on 2019/06/25.
////  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
////
//
//import UIKit
//
//private var overrideHeightKey = 0
//
//extension UITabBar {
//
//    /// 高さオーバーライド
//    public var overrideHeight: CGFloat? {
//        get {
//            return objc_getAssociatedObject(self, &overrideHeightKey) as? CGFloat
//        }
//        set {
//            objc_setAssociatedObject(self, &overrideHeightKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//    }
//
//    open override func sizeThatFits(_ size: CGSize) -> CGSize {
//        super.sizeThatFits(size)
//        guard UIApplication.shared.keyWindow != nil else {
//            return super.sizeThatFits(size)
//        }
//        var sizeThatFits = super.sizeThatFits(size)
//        if let overrideHeight = overrideHeight {
//            sizeThatFits.height = overrideHeight
//        }
//        return sizeThatFits
//    }
//}
