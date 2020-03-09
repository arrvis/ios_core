//
//  GroupChatWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupChatWireframe
final class GroupChatWireframe: NSObject, GroupChatWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.groupChatViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = GroupChatInteractor()
        let presenter = GroupChatPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = GroupChatWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showGroupSettingScreen(_ group: GroupData) {
        navigator.navigate(screen: AppScreens.groupSetting, payload: group)
    }

    func showReportMessageScreen(_ group: GroupData, _ message: Message) {
        navigator.navigate(screen: AppScreens.reportMessage, payload: (group, message))
    }
}
