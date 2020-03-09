//
//  HomeTopInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol HomeTopViewInterface: ViewInterface {
    func showLoginUser(_ loginUser: UserData)
}

protocol HomeTopPresenterInterface: PresenterInterface {
    func didTapLatestNotifications()
    func didTapChangeIcon()
    func didTapEditComment()
    func didTapExchangeCoin()
}

protocol HomeTopInteractorInterface: InteractorInterface {
    func fetchLoginUser()
    func updateIcon(_ image: UIImage?)
}

protocol HomeTopInteractorOutputInterface: InteractorOutputInterface {
    func fetchLoginUserCompleted(_ loginUser: UserData)
    func updateIconCompleted(_ loginUser: UserData)
}

protocol HomeTopWireframeInterface: WireframeInterface {
    func showLatestNotificationsScreen()
    func showEditCommentScreen()
    func showExchangeCoinListScreen()
}
