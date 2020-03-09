//
//  ReportMessagePresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 19/12/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - ReportMessagePresenter
final class ReportMessagePresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: ReportMessageInteractorInterface {
        return interactorInterface as! ReportMessageInteractorInterface
    }

    private weak var view: ReportMessageViewInterface? {
        return viewInterface as? ReportMessageViewInterface
    }

    private var wireframe: ReportMessageWireframeInterface {
        return wireframeInterface as! ReportMessageWireframeInterface
    }
}

// MARK: - ReportMessagePresenterInterface
extension ReportMessagePresenter: ReportMessagePresenterInterface {

    func didTapReport(_ comment: String) {
        if let payload = payload as? (GroupData, Message) {
            view?.showLoading()
            interactor.reportMessage(payload.0, payload.1, comment)
        } else if let payload = payload as? (NotificationData, NotificationCommentData) {
            view?.showLoading()
            interactor.reportMessage(payload.0, payload.1, comment)
        }
    }
}

// MARK: - ReportMessageInteractorOutputInterface
extension ReportMessagePresenter: ReportMessageInteractorOutputInterface {

    func reportMessageCompleted() {
        view?.hideLoading()
        view?.showOkAlert(nil, "通報しました", "OK", { [unowned self] in
            self.wireframe.dismissScreen()
        })
    }
}
