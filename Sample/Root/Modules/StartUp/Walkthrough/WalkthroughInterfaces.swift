//
//  WalkthroughInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol WalkthroughViewInterface: ViewInterface {
}

protocol WalkthroughPresenterInterface: PresenterInterface {
    func didTapNext()
}

protocol WalkthroughInteractorInterface: InteractorInterface {
    func markAsRead()
}

protocol WalkthroughInteractorOutputInterface: InteractorOutputInterface {
    func markAsReadCompleted()
}

protocol WalkthroughWireframeInterface: WireframeInterface {
    func showMainScreen()
}
