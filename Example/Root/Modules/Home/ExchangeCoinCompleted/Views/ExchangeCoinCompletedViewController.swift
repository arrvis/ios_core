//
//  ExchangeCoinCompletedViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - ExchangeCoinCompletedViewController
final class ExchangeCoinCompletedViewController: ViewBase {

    // MARK: - Variables

    private var presenter: ExchangeCoinCompletedPresenterInterface {
        return presenterInterface as! ExchangeCoinCompletedPresenterInterface
    }
}

// MARK: - ExchangeCoinCompletedViewInterface
extension ExchangeCoinCompletedViewController: ExchangeCoinCompletedViewInterface {
}
