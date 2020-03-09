//
//  GroupSettingWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupSettingWireframe
final class GroupSettingWireframe: NSObject, GroupSettingWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.groupSettingViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = GroupSettingInteractor()
        let presenter = GroupSettingPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = GroupSettingWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showGroupMemberListScreen(_ group: GroupData) {
        navigator.navigate(screen: AppScreens.groupMemberList, payload: group)
    }

    func showEditGroupScreen(_ group: GroupData) {
        navigator.navigate(screen: AppScreens.groupCreation, payload: group)
    }
}
