//
//  BaseTabBarController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/11/28.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// UITabBarController基底クラス
open class BaseTabBarController: UITabBarController, BarButtonItemSettableViewController {

    // MARK: Property

    lazy var defaultTabBarHeight = { tabBar.frame.height }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        initializePopGesture()
        handleDidFirstLayoutSubviews()
    }
}
