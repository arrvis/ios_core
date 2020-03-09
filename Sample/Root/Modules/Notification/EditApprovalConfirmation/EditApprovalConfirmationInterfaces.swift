//
//  EditApprovalConfirmationInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 22/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol EditApprovalConfirmationViewInterface: ViewInterface {
    func showApprovalConfirmation(_ approvalConfirmation: String?)
}

protocol EditApprovalConfirmationPresenterInterface: PresenterInterface {
    func didTapDone(_ approvalConfirmation: String?)
}

protocol EditApprovalConfirmationInteractorInterface: InteractorInterface {
}

protocol EditApprovalConfirmationInteractorOutputInterface: InteractorOutputInterface {
}

protocol EditApprovalConfirmationWireframeInterface: WireframeInterface {
}
