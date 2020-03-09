//
//  SelectCoinInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 28/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol SelectCoinViewInterface: ViewInterface {
    func showCoins(_ coins: [Coin])
}

protocol SelectCoinPresenterInterface: PresenterInterface {
    func didTapCoin(_ coin: Coin)
}

protocol SelectCoinInteractorInterface: InteractorInterface {
    func fetchCoins()
}

protocol SelectCoinInteractorOutputInterface: InteractorOutputInterface {
    func fetchCoinsCompelted(_ coins: [Coin])
}

protocol SelectCoinWireframeInterface: WireframeInterface {
}
