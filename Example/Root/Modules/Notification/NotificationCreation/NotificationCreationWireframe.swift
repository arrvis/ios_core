//
//  NotificationCreationWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - NotificationCreationWireframe
final class NotificationCreationWireframe: NSObject, NotificationCreationWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.notificationCreationViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! NotificationCreationViewController
        let interactor = NotificationCreationInteractor()
        let presenter = NotificationCreationPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = NotificationCreationWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showSelectGroupScreen(_ selectedGroups: [ResponsedGroup]) {
        navigator.navigate(screen: AppScreens.selectGroup, payload: selectedGroups)
    }

    func showEditApprovalConfirmationScreen(_ approvalConfirmation: String?) {
        navigator.navigate(screen: AppScreens.editApprovalConfirmation, payload: approvalConfirmation)
    }
}
