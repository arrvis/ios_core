//
//  ExchangeCoinDetailPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - ExchangeCoinDetailPresenter
final class ExchangeCoinDetailPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: ExchangeCoinDetailInteractorInterface {
        return interactorInterface as! ExchangeCoinDetailInteractorInterface
    }

    private weak var view: ExchangeCoinDetailViewInterface? {
        return viewInterface as? ExchangeCoinDetailViewInterface
    }

    private var wireframe: ExchangeCoinDetailWireframeInterface {
        return wireframeInterface as! ExchangeCoinDetailWireframeInterface
    }
}

// MARK: - ExchangeCoinDetailPresenterInterface
extension ExchangeCoinDetailPresenter: ExchangeCoinDetailPresenterInterface {
}

// MARK: - ExchangeCoinDetailInteractorOutputInterface
extension ExchangeCoinDetailPresenter: ExchangeCoinDetailInteractorOutputInterface {
}
