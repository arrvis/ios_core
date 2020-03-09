//
//  NotificationDetailInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import Foundation

// MARK: - NotificationDetailInteractor
final class NotificationDetailInteractor {

    // MARK: - Variables

    weak var output: NotificationDetailInteractorOutputInterface?
}

// MARK: - NotificationDetailInteractorInterface
extension NotificationDetailInteractor: NotificationDetailInteractorInterface {

    func markAsRead(_ notification: NotificationData) {
        if notification.notification.attributes.notReadersIds.contains(Int(UserService.loginUser!.data.id)!) {
            NotificationsService.markAsRead(notification.notification.id).subscribe(onNext: { [unowned self] ret in
                self.output?.didUpdated(ret)
            }, onError: { [unowned self] error in
                self.output?.handleError(error, nil)
            }).disposed(by: self)
        }
    }

    func approve(_ notification: NotificationData) {
        if notification.notification.attributes.notApprovingUserIds.contains(Int(UserService.loginUser!.data.id)!) {
            NotificationsService.approve(notification.notification.id).subscribe(onNext: { [unowned self] ret in
                self.output?.didUpdated(ret)
            }, onError: { [unowned self] error in
                self.output?.handleError(error, nil)
            }).disposed(by: self)
        }
    }

    func removeClap(_ notification: NotificationData, _ comment: NotificationCommentData) {
        NotificationsService.deleteClap(notification.notification.id, comment.notificationComment.id).subscribe(onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func addClap(_ notification: NotificationData, _ comment: NotificationCommentData) {
        NotificationsService.sendClap(notification.notification.id, comment.notificationComment.id).subscribe(onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func fetchComments(_ notification: NotificationData, _ page: Int?) {
        NotificationsService.fetchComments(notification.notification.id, page).subscribe(onNext: { [unowned self] ret in
            self.output?.fetchCommentsCompleted(ret.0, ret.1)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func comment(_ notification: NotificationData, _ comment: String) {
        NotificationsService.comment(notification.notification.id, comment).subscribe(onNext: { [unowned self] ret in
            self.output?.commentCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func sendFile(_ notification: NotificationData, _ files: [URL]) {
        NotificationsService.sendFile(notification.notification.id, files).subscribe(onNext: { [unowned self] ret in
            self.output?.commentCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func sendStamp(_ notification: NotificationData, _ id: String) {
        NotificationsService.stamp(notification.notification.id, id).subscribe(onNext: { [unowned self] ret in
            self.output?.commentCompleted(ret)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
