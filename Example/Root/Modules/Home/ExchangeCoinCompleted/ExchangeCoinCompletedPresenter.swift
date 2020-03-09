//
//  ExchangeCoinCompletedPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - ExchangeCoinCompletedPresenter
final class ExchangeCoinCompletedPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: ExchangeCoinCompletedInteractorInterface {
        return interactorInterface as! ExchangeCoinCompletedInteractorInterface
    }

    private weak var view: ExchangeCoinCompletedViewInterface? {
        return viewInterface as? ExchangeCoinCompletedViewInterface
    }

    private var wireframe: ExchangeCoinCompletedWireframeInterface {
        return wireframeInterface as! ExchangeCoinCompletedWireframeInterface
    }
}

// MARK: - ExchangeCoinCompletedPresenterInterface
extension ExchangeCoinCompletedPresenter: ExchangeCoinCompletedPresenterInterface {
}

// MARK: - ExchangeCoinCompletedInteractorOutputInterface
extension ExchangeCoinCompletedPresenter: ExchangeCoinCompletedInteractorOutputInterface {
}
