//
//  CoinTopInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol CoinTopViewInterface: ViewInterface {
}

protocol CoinTopPresenterInterface: PresenterInterface {
    func didTapLatestNotifications()
    func didTapSend()
}

protocol CoinTopInteractorInterface: InteractorInterface {
    func markAsRead()
}

protocol CoinTopInteractorOutputInterface: InteractorOutputInterface {
}

protocol CoinTopWireframeInterface: WireframeInterface {
    func showLatestNotificationsScreen()
    func showSendCoinScreen()
}
