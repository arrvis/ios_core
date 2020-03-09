//
//  NotificationCreationInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import Foundation

// MARK: - NotificationCreationInteractor
final class NotificationCreationInteractor {

    // MARK: - Variables

    weak var output: NotificationCreationInteractorOutputInterface?
}

// MARK: - NotificationCreationInteractorInterface
extension NotificationCreationInteractor: NotificationCreationInteractorInterface {

    func fetchGroups() {
        GroupService.fetchGroups().subscribe(onNext: { [unowned self] ret in
            self.output?.fetchGroupsCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func post(
        _ original: NotificationData?,
        _ groups: [ResponsedGroup],
        _ title: String,
        _ content: String,
        _ attachments: [AttachmentData],
        _ isRequiredApproval: Bool,
        _ approvalConfirmation: String?,
        _ approvingDeadline: Date?,
        _ isRequiredRead: Bool) {
        NotificationsService.postNotification(original, groups, title, content, attachments, isRequiredApproval, approvalConfirmation, approvingDeadline, isRequiredRead).subscribe(onNext: { [unowned self] ret in
            self.output?.postCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
