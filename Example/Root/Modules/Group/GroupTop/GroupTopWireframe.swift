//
//  GroupTopWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupTopWireframe
final class GroupTopWireframe: NSObject, GroupTopWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.groupTopViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! GroupTopViewController
        let interactor = GroupTopInteractor()
        let presenter = GroupTopPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = GroupTopWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showLatestNotificationsScreen() {
        navigator.navigate(screen: AppScreens.latestNotifications)
    }

    func showSelectMemberScreen() {
        navigator.navigate(screen: AppScreens.selectMember, payload: AppScreens.groupCreation, fromRoot: true)
    }

    func showGroupChatScreen(_ group: GroupData) {
        navigator.navigate(screen: AppScreens.groupChat, payload: group, fromRoot: true)
    }
}
