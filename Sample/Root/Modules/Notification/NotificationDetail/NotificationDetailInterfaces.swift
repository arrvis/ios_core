//
//  NotificationDetailInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol NotificationDetailViewInterface: ViewInterface {
    func showNotification(_ loginUser: UserData, _ notification: NotificationData)
    func reload(_ notification: NotificationData)
    func showComments(_ comments: [NotificationCommentData])
    func showMoreComments(_ comments: [NotificationCommentData])
    func showSendComment(_ comment: NotificationCommentData)
    func showContentMenu()
    func showMessageMenu(_ canReport: Bool, _ canCopy: Bool)
    func copyToClipBoard(_ text: String)
}

protocol NotificationDetailPresenterInterface: PresenterInterface {
    func didTapEdit()
    func didLongPressContent()
    func didTapCopyContent()
    func didTapApproval()
    func didTapAttachment(_ data: AttachmentData)
    func didTapRemoveClap(_ comment: NotificationCommentData)
    func didTapAddClap(_ comment: NotificationCommentData)
    func didTapFile()
    func didTapImage()
    func didTapSendMessage(_ content: String)
    func didTapStamp(_ id: String)
    func didLongPress(_ comment: NotificationCommentData)
    func didTapCopyMessage()
    func didTapReportMessage()
    func didReachBottom()
}

protocol NotificationDetailInteractorInterface: InteractorInterface {
    func markAsRead(_ notification: NotificationData)
    func approve(_ notification: NotificationData)
    func removeClap(_ notification: NotificationData, _ comment: NotificationCommentData)
    func addClap(_ notification: NotificationData, _ comment: NotificationCommentData)
    func fetchComments(_ notification: NotificationData, _ page: Int?)
    func comment(_ notification: NotificationData, _ comment: String)
    func sendFile(_ notification: NotificationData, _ files: [URL])
    func sendStamp(_ notification: NotificationData, _ id: String)
}

protocol NotificationDetailInteractorOutputInterface: InteractorOutputInterface {
    func didUpdated(_ notification: NotificationData)
    func fetchCommentsCompleted(_ comments: [NotificationCommentData], _ pagenation: Pagenation)
    func commentCompleted(_ send: NotificationCommentData)
}

protocol NotificationDetailWireframeInterface: WireframeInterface {
    func showEditNotificationScreen(_ notification: NotificationData)
    func showReportMessageScreen(_ notification: NotificationData, _ comment: NotificationCommentData)
}
