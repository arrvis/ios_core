//
//  GroupSettingInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol GroupSettingViewInterface: ViewInterface {
    func showData(_ loginUser: UserData, _ group: GroupData)
}

protocol GroupSettingPresenterInterface: PresenterInterface {
    func didTapMemberList()
    func didTapEditGroup()
    func didChangeNotificationEnabled(_ enabled: Bool)
    func didTapUnsubscribeGroup()
}

protocol GroupSettingInteractorInterface: InteractorInterface {
    func fetchLoginUser()
    func leaveGroup(_ group: GroupData)
}

protocol GroupSettingInteractorOutputInterface: InteractorOutputInterface {
    func fetchLoginUserCompleted(_ loginUser: UserData)
    func leaveGroupCompleted()
}

protocol GroupSettingWireframeInterface: WireframeInterface {
    func showGroupMemberListScreen(_ group: GroupData)
    func showEditGroupScreen(_ group: GroupData)
}
