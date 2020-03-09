//
//  SplashInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol SplashViewInterface: ViewInterface {
}

protocol SplashPresenterInterface: PresenterInterface {
}

protocol SplashInteractorInterface: InteractorInterface {
    func fetchIsSignedIn()
}

protocol SplashInteractorOutputInterface: InteractorOutputInterface {
    func fetchIsSignedInCompleted(
        _ isSignedIn: Bool,
        _ didDisplayRequestPermissions: Bool,
        _ didDisplayWalkthrough: Bool
    )
}

protocol SplashWireframeInterface: WireframeInterface {
    func showTopScreen()
    func showRequestPermissionsScreen()
    func showWalkthroughScreen()
    func showMainScreen()
}
