//
//  AppTabBarController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

/// アプリTabBarController基底クラス
open class AppTabBarController: BaseTabBarController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = AppStyles.colorRed
        tabBar.unselectedItemTintColor = AppStyles.colorDarkGray
        tabBar.barTintColor = AppStyles.colorWhite
        configureStatusBar()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationItem()
        UITabBarItem.appearance().setTitleTextAttributes([.font: AppStyles.font.withSize(10 * fontScaleRatio)], for: .normal)
    }
}
