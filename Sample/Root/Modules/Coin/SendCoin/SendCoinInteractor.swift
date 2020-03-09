//
//  SendCoinInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - SendCoinInteractor
final class SendCoinInteractor {

    // MARK: - Variables

    weak var output: SendCoinInteractorOutputInterface?
}

// MARK: - SendCoinInteractorInterface
extension SendCoinInteractor: SendCoinInteractorInterface {

    func fetchLoginUser() {
        output?.fetchLoginUserCompleted(UserService.loginUser!)
    }

    func fetchCoins() {
        output?.fetchCoinsCompleted(CoinService.coins)
    }

    func sendCoin(_ user: UserData, _ coin: Coin, _ pointNum: Int, _ comment: String) {
        PresentsService.sendPresent(coin.id, user.data.id, pointNum, comment).subscribe(onNext: { [unowned self] _ in
            self.output?.sendCoinCompleted()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
