//
//  SelectCoinPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 28/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - SelectCoinPresenter
final class SelectCoinPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: SelectCoinInteractorInterface {
        return interactorInterface as! SelectCoinInteractorInterface
    }

    private weak var view: SelectCoinViewInterface? {
        return viewInterface as? SelectCoinViewInterface
    }

    private var wireframe: SelectCoinWireframeInterface {
        return wireframeInterface as! SelectCoinWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchCoins()
    }
}

// MARK: - SelectCoinPresenterInterface
extension SelectCoinPresenter: SelectCoinPresenterInterface {

    func didTapCoin(_ coin: Coin) {
        wireframe.popScreen(result: coin, true)
    }
}

// MARK: - SelectCoinInteractorOutputInterface
extension SelectCoinPresenter: SelectCoinInteractorOutputInterface {

    func fetchCoinsCompelted(_ coins: [Coin]) {
        view?.showCoins(coins)
    }
}
