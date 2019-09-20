//
//  BaseTableViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/15.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

/// UITableViewController基底クラス
open class BaseTableViewController: UITableViewController,
    BackFromNextHandleable,
    BarButtonItemSettable,
    DidFirstLayoutSubviewsHandleable,
    KeyboardDisplayable {

    // MARK: - Life-Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        handleDidFirstLayoutSubviews()
        initializePopGesture()
        initializeBarButtonItemsIfNeed()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeKeyboardEventsIfNeed()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeKeyboardEventsIfNeed()
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
