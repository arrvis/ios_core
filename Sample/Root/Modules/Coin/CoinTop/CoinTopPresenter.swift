//
//  CoinTopPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - CoinTopPresenter
final class CoinTopPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: CoinTopInteractorInterface {
        return interactorInterface as! CoinTopInteractorInterface
    }

    private weak var view: CoinTopViewInterface? {
        return viewInterface as? CoinTopViewInterface
    }

    private var wireframe: CoinTopWireframeInterface {
        return wireframeInterface as! CoinTopWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.markAsRead()
    }
}

// MARK: - CoinTopPresenterInterface
extension CoinTopPresenter: CoinTopPresenterInterface {

    func didTapLatestNotifications() {
        wireframe.showLatestNotificationsScreen()
    }

    func didTapSend() {
        wireframe.showSendCoinScreen()
    }
}

// MARK: - CoinTopInteractorOutputInterface
extension CoinTopPresenter: CoinTopInteractorOutputInterface {
}
