//
//  MainInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol MainViewInterface: ViewInterface {
    func showViewControllers()
    func showBadgeCounts(_ footer: Footer)
}

protocol MainPresenterInterface: PresenterInterface {
}

protocol MainInteractorInterface: InteractorInterface {
    func loadData()
}

protocol MainInteractorOutputInterface: InteractorOutputInterface {
    func loadDataCompleted()
    func fetchBadgeCountsCompleted(_ footer: Footer)
}

protocol MainWireframeInterface: WireframeInterface {
}
