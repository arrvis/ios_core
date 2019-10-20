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
open class BaseNavigationController: UINavigationController, ViewControllerProtocols {

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
        initializeForProtocols()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearForProtocols()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisAppearForProtocols()
    }

    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            completion?()
            SwiftEventBus.post(SystemBusEvents.currentViewControllerChanged)
        }
    }

    // MARK: - ExtendsViewControllerEventsHandleable

    /// 初回layoutSubviews
    open func onDidFirstLayoutSubviews() {}

    /// 次画面から戻ってきた
    ///
    /// - Parameter result: result
    open func onBackFromNext(_ result: Any?) {}

    // MARK: - BarButtonItemSettable

    /// 戻るBarButtonItem
    public var backBarButtonItem: UIBarButtonItem? { return nil }

    /// 左BarButtonItems
    public var leftBarButtonItems: [UIBarButtonItem]? { return nil }

    /// 右BarButtonItems
    public var rightBarButtonItems: [UIBarButtonItem]? { return nil }

    /// 戻るBarButtonItemタップ
    public func didTapBackBarButtonItem() {}

    /// 左BarButtonItemタップ
    public func didTapLeftBarButtonItem(_ index: Int) {}

    /// 右BarButtonItemタップ
    public func didTapRightBarButtonItem(_ index: Int) {}
}

// MARK: - UINavigationControllerDelegate
extension BaseNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        SwiftEventBus.post(SystemBusEvents.currentViewControllerChanged)
    }
}
