//
//  EditApprovalConfirmationPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 22/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - EditApprovalConfirmationPresenter
final class EditApprovalConfirmationPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: EditApprovalConfirmationInteractorInterface {
        return interactorInterface as! EditApprovalConfirmationInteractorInterface
    }

    private weak var view: EditApprovalConfirmationViewInterface? {
        return viewInterface as? EditApprovalConfirmationViewInterface
    }

    private var wireframe: EditApprovalConfirmationWireframeInterface {
        return wireframeInterface as! EditApprovalConfirmationWireframeInterface
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showApprovalConfirmation(payload as? String)
    }
}

// MARK: - EditApprovalConfirmationPresenterInterface
extension EditApprovalConfirmationPresenter: EditApprovalConfirmationPresenterInterface {

    func didTapDone(_ approvalConfirmation: String?) {
        wireframe.popScreen(result: approvalConfirmation, true)
    }
}

// MARK: - EditApprovalConfirmationInteractorOutputInterface
extension EditApprovalConfirmationPresenter: EditApprovalConfirmationInteractorOutputInterface {
}
