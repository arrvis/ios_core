//
//  TopInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol TopViewInterface: ViewInterface {
}

protocol TopPresenterInterface: PresenterInterface {
    func didTapLogin()
    func didTapForgotPassword()
}

protocol TopInteractorInterface: InteractorInterface {
}

protocol TopInteractorOutputInterface: InteractorOutputInterface {
}

protocol TopWireframeInterface: WireframeInterface {
    func showLoginScreen()
    func showResetPasswordScreen()
}
