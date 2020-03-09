//
//  MoreTopInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol MoreTopViewInterface: ViewInterface {
    func showLoginUser(_ loginUser: UserData)
    func showNotificationEnabled(_ enabled: Bool)
}

protocol MoreTopPresenterInterface: PresenterInterface {
    func didTapLatestNotifications()
    func didTapMenu()
    func didTapHelp()
    func didTapChangeTextSize()
    func didTapNotificationEnabled()
}

protocol MoreTopInteractorInterface: InteractorInterface {
    func fetchLoginUser()
    func fetchNotificationEnabled()
    func logout()
}

protocol MoreTopInteractorOutputInterface: InteractorOutputInterface {
    func fetchLoginUserCompleted(_ loginUser: UserData)
    func fetchNotificationEnabledCompleted(_ enabled: Bool)
    func logoutCompleted()
}

protocol MoreTopWireframeInterface: WireframeInterface {
    func showLatestNotificationsScreen()
    func showHelpScreen()
    func showChangeTextSizeScreen()
    func showTopScreen()
}
