//
//  ReportMessageInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 19/12/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol ReportMessageViewInterface: ViewInterface {
}

protocol ReportMessagePresenterInterface: PresenterInterface {
    func didTapReport(_ comment: String)
}

protocol ReportMessageInteractorInterface: InteractorInterface {
    func reportMessage(_ group: GroupData, _ message: Message, _ comment: String)
    func reportMessage(_ notification: NotificationData, _ notificationCOmment: NotificationCommentData, _ comment: String)
}

protocol ReportMessageInteractorOutputInterface: InteractorOutputInterface {
    func reportMessageCompleted()
}

protocol ReportMessageWireframeInterface: WireframeInterface {
}
