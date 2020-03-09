//
//  SelectCoinInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 28/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - SelectCoinInteractor
final class SelectCoinInteractor {

    // MARK: - Variables

    weak var output: SelectCoinInteractorOutputInterface?
}

// MARK: - SelectCoinInteractorInterface
extension SelectCoinInteractor: SelectCoinInteractorInterface {

    func fetchCoins() {
        output?.fetchCoinsCompelted(CoinService.coins)
    }
}
