//
//  HelpInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 04/03/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol HelpViewInterface: ViewInterface {
    func showHelps(_ helps: [HelpData])
}

protocol HelpPresenterInterface: PresenterInterface {
    func didTapHelp(_ help: HelpData)
}

protocol HelpInteractorInterface: InteractorInterface {
    func fetchHelps()
}

protocol HelpInteractorOutputInterface: InteractorOutputInterface {
    func fetchHelpsCompleted(_ helps: [HelpData])
}

protocol HelpWireframeInterface: WireframeInterface {
    func showHelpDetailScreen(_ help: HelpData)
}
