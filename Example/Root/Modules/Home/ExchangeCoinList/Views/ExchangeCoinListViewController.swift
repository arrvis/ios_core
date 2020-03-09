//
//  ExchangeCoinListViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - ExchangeCoinListViewController
final class ExchangeCoinListViewController: ViewBase {

    // MARK: - Variables

    private var presenter: ExchangeCoinListPresenterInterface {
        return presenterInterface as! ExchangeCoinListPresenterInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.exchangeCoin()
    }
}

// MARK: - ExchangeCoinListViewInterface
extension ExchangeCoinListViewController: ExchangeCoinListViewInterface {
}
