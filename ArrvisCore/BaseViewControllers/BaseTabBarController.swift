//
//  BaseTabBarController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/11/28.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// UITabBarController基底クラス
open class BaseTabBarController: UITabBarController {

    // MARK: - Variables

    /// デフォルトのタブバー高さ
    public lazy var defaultTabBarHeight = { tabBar.frame.height }()

    // NARK:  - Events

    /// 初回SubViewsLayout
    open func onDidFirstLayoutSubviews() {}

    // MARK: - Life-Cycle

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didFirstLayoutSubviews {
            return
        }
        didFirstLayoutSubviews = true
        onDidFirstLayoutSubviews()
    }
}
