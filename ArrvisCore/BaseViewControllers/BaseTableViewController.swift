//
//  BaseTableViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/15.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// UITableViewController基底クラス
open class BaseTableViewController: UITableViewController, ViewControllerProtocols {

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

    // MARK: - KeyboardDisplayable

    public var scrollViewForResizeKeyboard: UIScrollView? { return nil }
}
