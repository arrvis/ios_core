//
//  SendCoinInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol SendCoinViewInterface: ViewInterface {
    func showLoginUser(_ loginUser: UserData)
    func showToUser(_ user: UserData?)
    func showCoin(_ coin: Coin)
}

protocol SendCoinPresenterInterface: PresenterInterface {
    func didTapSelectMember()
    func didTapSelectCoin()
    func didTapSend(_ pointNum: Int, _ comment: String)
}

protocol SendCoinInteractorInterface: InteractorInterface {
    func fetchLoginUser()
    func fetchCoins()
    func sendCoin(_ user: UserData, _ coin: Coin, _ pointNum: Int, _ comment: String)
}

protocol SendCoinInteractorOutputInterface: InteractorOutputInterface {
    func fetchLoginUserCompleted(_ loginUser: UserData)
    func fetchCoinsCompleted(_ coins: [Coin])
    func sendCoinCompleted()
}

protocol SendCoinWireframeInterface: WireframeInterface {
    func showSelectMemberScreen()
    func showSelectCoinScreen()
}
