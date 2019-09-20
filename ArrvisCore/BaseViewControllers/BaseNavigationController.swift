//
//  BaseNavigationController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/11/28.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import SwiftEventBus

/// UINavigationController基底クラス
open class BaseNavigationController: UINavigationController,
    BackFromNextHandleable,
    BarButtonItemSettable,
    DidFirstLayoutSubviewsHandleable,
    KeyboardDisplayable {

    // MARK: - Variables

    /// Delegate
    open override var delegate: UINavigationControllerDelegate? {
        didSet {
            if (delegate as? BaseNavigationController) != self {
                fatalError("Not permitted")
            }
        }
    }

    /// 透明なNavigationBarかどうか
    open var transparentNavigationBar: Bool {
        return false
    }

    // MARK: - Life-Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if transparentNavigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
        handleDidFirstLayoutSubviews()
        initializeBarButtonItemsIfNeed()
    }

    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            completion?()
            SwiftEventBus.post(SystemBusEvents.currentViewControllerChanged)
        }
    }

    // MARK: - BackFromNextHandleable

    open func onBackFromNext(_ result: Any?) {}

    // MARK: - BarButtonItemSettable

    open func didTapBackBarButtonItem() {}
    open func didTapLeftBarButtonItem(_ index: Int) {}
    open func didTapRightBarButtonItem(_ index: Int) {}

    // MARK: - DidFirstLayoutSubviewsHandleable

    open func onDidFirstLayoutSubviews() {}
}

// MARK: - UINavigationControllerDelegate
extension BaseNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        SwiftEventBus.post(SystemBusEvents.currentViewControllerChanged)
    }
}
