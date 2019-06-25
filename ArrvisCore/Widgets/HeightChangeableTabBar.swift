//
//  HeightChangeableTabBar.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/25.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// 高さ変更可能なTabBar
open class HeightChangeableTabbar: UITabBar {

    /// 高さオーバーライド
    open var overrideHeight: CGFloat? {
        return 50
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if let overrideHeight = overrideHeight {
            size.height = overrideHeight
        }
        return size
    }
}
