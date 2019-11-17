//
//  BaseTabBarController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/11/28.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// UITabBarController基底クラス
open class BaseTabBarController: UITabBarController, ViewControllerProtocols {

    // MARK: - Variables

    lazy var defaultTabBarHeight = { tabBar.frame.height }()

    // MARK: - Life-Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        initializeForProtocols()
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
    open var backBarButtonItem: UIBarButtonItem? { return nil }

    /// 左BarButtonItems
    open var leftBarButtonItems: [UIBarButtonItem]? { return nil }

    /// 右BarButtonItems
    open var rightBarButtonItems: [UIBarButtonItem]? { return nil }

    /// 戻るBarButtonItemタップ
    open func didTapBackBarButtonItem() {}

    /// 左BarButtonItemタップ
    open func didTapLeftBarButtonItem(_ index: Int) {}

    /// 右BarButtonItemタップ
    open func didTapRightBarButtonItem(_ index: Int) {}

    // MARK: - KeyboardDisplayable

    open var scrollViewForResizeKeyboard: UIScrollView? { return nil }
}
