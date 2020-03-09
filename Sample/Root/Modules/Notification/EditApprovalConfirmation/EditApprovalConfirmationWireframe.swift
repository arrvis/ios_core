//
//  EditApprovalConfirmationWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 22/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - EditApprovalConfirmationWireframe
final class EditApprovalConfirmationWireframe: NSObject, EditApprovalConfirmationWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.editApprovalConfirmationViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = EditApprovalConfirmationInteractor()
        let presenter = EditApprovalConfirmationPresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = EditApprovalConfirmationWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
