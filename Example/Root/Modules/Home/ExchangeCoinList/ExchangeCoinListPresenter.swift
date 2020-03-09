//
//  ExchangeCoinListPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - ExchangeCoinListPresenter
final class ExchangeCoinListPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: ExchangeCoinListInteractorInterface {
        return interactorInterface as! ExchangeCoinListInteractorInterface
    }

    private weak var view: ExchangeCoinListViewInterface? {
        return viewInterface as? ExchangeCoinListViewInterface
    }

    private var wireframe: ExchangeCoinListWireframeInterface {
        return wireframeInterface as! ExchangeCoinListWireframeInterface
    }
}

// MARK: - ExchangeCoinListPresenterInterface
extension ExchangeCoinListPresenter: ExchangeCoinListPresenterInterface {
}

// MARK: - ExchangeCoinListInteractorOutputInterface
extension ExchangeCoinListPresenter: ExchangeCoinListInteractorOutputInterface {
}
