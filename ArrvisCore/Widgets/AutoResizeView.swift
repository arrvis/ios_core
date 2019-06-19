//
//  AutoResizeView.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// 自動でリサイズするView
open class AutoResizeView: UIView {

    // MARK: - Variables

    open override var intrinsicContentSize: CGSize {
        return maxSubViewSize
    }
}
