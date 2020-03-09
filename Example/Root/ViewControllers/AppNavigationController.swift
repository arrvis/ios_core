//
//  AppNavigationController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

/// アプリNavigationController基底クラス
open class AppNavigationController: BaseNavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = AppStyles.colorNavy
        navigationBar.barTintColor = AppStyles.colorWhite
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationBar.layer.shadowRadius = 0.5
        navigationBar.layer.shadowOpacity = 0.2
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: AppStyles.fontBold.withSize(17 * fontScaleRatio),
            NSAttributedString.Key.foregroundColor: AppStyles.colorText
        ]
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool) {
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: AppStyles.fontBold.withSize(17 * fontScaleRatio),
            NSAttributedString.Key.foregroundColor: AppStyles.colorText
        ]
    }
}
