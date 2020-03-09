//
//  NotificationCreationInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol NotificationCreationViewInterface: ViewInterface {
    func showEditData(_ data: NotificationData)
    func showSelectedGroups(_ groups: [ResponsedGroup], _ allGroupsCount: Int)
    func showSelectedAttachment(_ data: AttachmentData)
    func showApprovalConfirmation(_ approvalConfirmation: String?)
}

protocol NotificationCreationPresenterInterface: PresenterInterface {
    func didTapPost(
        _ title: String,
        _ content: String,
        _ isRequiredApproval: Bool,
        _ approvingDeadline: Date?,
        _ isRequiredRead: Bool)
    func didTapSelectGroup()
    func didTapAddFile()
    func didTapAddImage()
    func didTapAttachment(_ data: AttachmentData)
    func didTapRemoveFile(_ data: AttachmentData)
    func didTapApprovalConfirmation()
}

protocol NotificationCreationInteractorInterface: InteractorInterface {
    func fetchGroups()
    func post(
        _ original: NotificationData?,
        _ groups: [ResponsedGroup],
        _ title: String,
        _ content: String,
        _ attachments: [AttachmentData],
        _ isRequiredApproval: Bool,
        _ approvalConfirmation: String?,
        _ approvingDeadline: Date?,
        _ isRequiredRead: Bool)
}

protocol NotificationCreationInteractorOutputInterface: InteractorOutputInterface {
    func fetchGroupsCompleted(_ groups: [ResponsedGroup])
    func postCompleted(_ posted: ResponsedNotification)
}

protocol NotificationCreationWireframeInterface: WireframeInterface {
    func showSelectGroupScreen(_ selectedGroups: [ResponsedGroup])
    func showEditApprovalConfirmationScreen(_ approvalConfirmation: String?)
}
