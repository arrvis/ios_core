//
//  HelpDetailInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol HelpDetailViewInterface: ViewInterface {
    func showHelp(_ help: HelpData)
}

protocol HelpDetailPresenterInterface: PresenterInterface {
}

protocol HelpDetailInteractorInterface: InteractorInterface {
}

protocol HelpDetailInteractorOutputInterface: InteractorOutputInterface {
}

protocol HelpDetailWireframeInterface: WireframeInterface {
}
