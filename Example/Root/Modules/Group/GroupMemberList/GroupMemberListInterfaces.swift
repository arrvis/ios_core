//
//  GroupMemberListInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol GroupMemberListViewInterface: ViewInterface {
    func showMembers(_ group: GroupData)
}

protocol GroupMemberListPresenterInterface: PresenterInterface {
}

protocol GroupMemberListInteractorInterface: InteractorInterface {
}

protocol GroupMemberListInteractorOutputInterface: InteractorOutputInterface {
}

protocol GroupMemberListWireframeInterface: WireframeInterface {
}
