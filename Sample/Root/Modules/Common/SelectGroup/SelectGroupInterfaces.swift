//
//  SelectGroupInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 18/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol SelectGroupViewInterface: ViewInterface {
    func showGroups(_ groups: [ResponsedGroup], _ selectedGroups: [ResponsedGroup])
}

protocol SelectGroupPresenterInterface: PresenterInterface {
    func didTapDone(_ selectedGroups: [ResponsedGroup])
}

protocol SelectGroupInteractorInterface: InteractorInterface {
    func fetchGroups()
}

protocol SelectGroupInteractorOutputInterface: InteractorOutputInterface {
    func fetchGroupsCompleted(_ groups: [ResponsedGroup])
}

protocol SelectGroupWireframeInterface: WireframeInterface {
}
