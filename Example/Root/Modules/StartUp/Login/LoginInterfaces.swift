//
//  LoginInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol LoginViewInterface: ViewInterface {
}

protocol LoginPresenterInterface: PresenterInterface {
    func didTapLogin(_ id: String, _ password: String)
}

protocol LoginInteractorInterface: InteractorInterface {
    func login(_ id: String, _ password: String)
}

protocol LoginInteractorOutputInterface: InteractorOutputInterface {
    func onLoginSucceeded()
}

protocol LoginWireframeInterface: WireframeInterface {
    func showRequestPermissionsScreen()
}
