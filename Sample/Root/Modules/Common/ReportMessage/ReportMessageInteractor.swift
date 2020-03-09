//
//  ReportMessageInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 19/12/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - ReportMessageInteractor
final class ReportMessageInteractor {

    // MARK: - Variables

    weak var output: ReportMessageInteractorOutputInterface?
}

// MARK: - ReportMessageInteractorInterface
extension ReportMessageInteractor: ReportMessageInteractorInterface {

    func reportMessage(_ group: GroupData, _ message: Message, _ comment: String) {
        GroupService.reportMessage(group, message, comment).subscribe(onNext: { [unowned self] _ in
            self.output?.reportMessageCompleted()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func reportMessage(_ notification: NotificationData, _ notificationCOmment: NotificationCommentData, _ comment: String) {
        NotificationsService.reportMessage(notification, notificationCOmment, comment).subscribe(onNext: { [unowned self] _ in
            self.output?.reportMessageCompleted()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
