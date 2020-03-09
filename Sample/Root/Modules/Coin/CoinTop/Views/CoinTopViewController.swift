//
//  CoinTopViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - CoinTopViewController
final class CoinTopViewController: ViewBase {

    // MARK: - Variables

    private var presenter: CoinTopPresenterInterface {
        return presenterInterface as! CoinTopPresenterInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.coin()
        configureRightItemsToBlue()
    }

    // MARK: - Overrides

    override func didTapLeftBarButtonItem(_ index: Int) {
        presenter.didTapLatestNotifications()
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapSend()
    }
}

// MARK: - CoinTopViewInterface
extension CoinTopViewController: CoinTopViewInterface {
}
