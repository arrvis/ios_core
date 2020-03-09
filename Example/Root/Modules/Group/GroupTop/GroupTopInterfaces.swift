//
//  GroupTopInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol GroupTopViewInterface: ViewInterface {
    func showLoginUser(_ loginUser: UserData)
    func showGroups(_ groups: [GroupData])
}

protocol GroupTopPresenterInterface: PresenterInterface {
    func didTapLatestNotifications()
    func didTapGroupCreation()
    func didTapGroup(_ group: GroupData)
}

protocol GroupTopInteractorInterface: InteractorInterface {
    func fetchLoginUser()
    func fetchGroupsWithData(_ startSubscribe: Bool)
    func unsubscribe()
}

protocol GroupTopInteractorOutputInterface: InteractorOutputInterface {
    func fetchLoginUserCompleted(_ loginUser: UserData)
    func fetchGroupsWithDataCompleted(_ groups: [GroupData])
}

protocol GroupTopWireframeInterface: WireframeInterface {
    func showLatestNotificationsScreen()
    func showSelectMemberScreen()
    func showGroupChatScreen(_ group: GroupData)
}
