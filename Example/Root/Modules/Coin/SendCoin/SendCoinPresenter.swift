//
//  SendCoinPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - SendCoinPresenter
final class SendCoinPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: SendCoinInteractorInterface {
        return interactorInterface as! SendCoinInteractorInterface
    }

    private weak var view: SendCoinViewInterface? {
        return viewInterface as? SendCoinViewInterface
    }

    private var wireframe: SendCoinWireframeInterface {
        return wireframeInterface as! SendCoinWireframeInterface
    }

    private var toUser: UserData? {
        didSet {
            view?.showToUser(toUser)
        }
    }

    private var coins = [Coin]()
    private var selectedCoin: Coin! {
        didSet {
            view?.showCoin(selectedCoin)
        }
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchLoginUser()
        interactor.fetchCoins()
    }

    override func onBackFromNext(_ result: Any?) {
        if let members = result as? [UserData] {
            toUser = members.first
        } else if let coin = result as? Coin {
            selectedCoin = coin
        }
    }
}

// MARK: - SendCoinPresenterInterface
extension SendCoinPresenter: SendCoinPresenterInterface {

    func didTapSelectMember() {
        wireframe.showSelectMemberScreen()
    }

    func didTapSelectCoin() {
        wireframe.showSelectCoinScreen()
    }

    func didTapSend(_ pointNum: Int, _ comment: String) {
        view?.showLoading()
        interactor.sendCoin(toUser!, selectedCoin, pointNum, comment)
    }
}

// MARK: - SendCoinInteractorOutputInterface
extension SendCoinPresenter: SendCoinInteractorOutputInterface {

    func fetchLoginUserCompleted(_ loginUser: UserData) {
        view?.showLoginUser(loginUser)
    }

    func fetchCoinsCompleted(_ coins: [Coin]) {
        self.coins = coins
        selectedCoin = coins.first!
        if let payload = payload as? UserData {
            toUser = payload
        }
    }

    func sendCoinCompleted() {
        view?.hideLoading()
        wireframe.dismissScreen()
    }
}
