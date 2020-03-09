//
//  ExchangeCoinDetailViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - ExchangeCoinDetailViewController
final class ExchangeCoinDetailViewController: ViewBase {

    // MARK: - Variables

    private var presenter: ExchangeCoinDetailPresenterInterface {
        return presenterInterface as! ExchangeCoinDetailPresenterInterface
    }
}

// MARK: - ExchangeCoinDetailViewInterface
extension ExchangeCoinDetailViewController: ExchangeCoinDetailViewInterface {
}
