//
//  ViewBases.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore

open class ViewBase: AppBaseViewController, ViewInterface {

    // MARK: - Life-Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        presenterInterface.viewDidLoad()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenterInterface.viewWillAppear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenterInterface.viewDidAppear(animated)
    }

    open override func onDidFirstLayoutSubviews() {
        super.onDidFirstLayoutSubviews()
        presenterInterface.onDidFirstLayoutSubviews()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenterInterface.viewWillDisappear(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenterInterface.viewDidDisappear(animated)
    }

    open override func onBackFromNext(_ result: Any?) {
        super.onBackFromNext(result)
        presenterInterface.onBackFromNext(result)
    }
}

open class TabBarViewBase: AppTabBarController, ViewInterface {

    // MARK: - Life-Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        presenterInterface.viewDidLoad()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenterInterface.viewWillAppear(animated)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenterInterface.viewDidAppear(animated)
    }

    open override func onDidFirstLayoutSubviews() {
        super.onDidFirstLayoutSubviews()
        presenterInterface.onDidFirstLayoutSubviews()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenterInterface.viewWillDisappear(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenterInterface.viewDidDisappear(animated)
    }

    open override func onBackFromNext(_ result: Any?) {
        super.onBackFromNext(result)
        presenterInterface.onBackFromNext(result)
    }
}
