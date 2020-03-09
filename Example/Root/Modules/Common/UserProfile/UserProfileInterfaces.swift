//
//  UserProfileInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol UserProfileViewInterface: ViewInterface {
    func showUser(_ user: UserData)
}

protocol UserProfilePresenterInterface: PresenterInterface {
    func getUserId() -> String
    func didTapSendCoin()
}

protocol UserProfileInteractorInterface: InteractorInterface {
    func fetchUser(_ userId: String)
}

protocol UserProfileInteractorOutputInterface: InteractorOutputInterface {
    func fetchUserCompleted(_ user: UserData)
}

protocol UserProfileWireframeInterface: WireframeInterface {
    func showSendCoinScreen(_ user: UserData)
}
