//
//  NotificationDetailPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import MobileCoreServices

// MARK: - NotificationDetailPresenter
final class NotificationDetailPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: NotificationDetailInteractorInterface {
        return interactorInterface as! NotificationDetailInteractorInterface
    }

    private weak var view: NotificationDetailViewInterface? {
        return viewInterface as? NotificationDetailViewInterface
    }

    private var wireframe: NotificationDetailWireframeInterface {
        return wireframeInterface as! NotificationDetailWireframeInterface
    }

    private var loginUser: UserData? {
        return (payload as? (UserData, NotificationData))?.0
    }

    private var notification: NotificationData? {
        return (payload as? (UserData, NotificationData))?.1
    }

    private var longPressedMessage: NotificationCommentData?

    private var currentPagenation: Pagenation?
    private var isFetching = false

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let loginUser = loginUser, let notification = notification {
            view?.showNotification(loginUser, notification)
            interactor.markAsRead(notification)
            interactor.fetchComments(notification, nil)
        }
    }

    override func onBackFromNext(_ result: Any?) {
        if let result = result as? ResponsedNotification {
            payload = (loginUser, NotificationData(notification: result, included: notification!.included))
             if let loginUser = loginUser, let notification = notification {
                view?.showNotification(loginUser, notification)
            }
        }
    }

    // MARK: - CameraRollEventHandler

    override func onImageSelected(_ image: UIImage, _ info: [UIImagePickerController.InfoKey: Any]) {
        if let url = info[.imageURL] as? URL {
            view?.showLoading()
            interactor.sendFile(notification!, [url])
        } else {
            view?.showLoading()
            let directory = NSTemporaryDirectory()
            let fileName = "\(NSUUID().uuidString).png"
            let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])!
            if (try? image.pngData()?.write(to: fullURL)) != nil {
                interactor.sendFile(notification!, [fullURL])
            }
        }
    }

    override func onMediaSelected(_ url: URL, _ info: [UIImagePickerController.InfoKey: Any]) {
        view?.showLoading()
        interactor.sendFile(notification!, [url])
    }
}

// MARK: - UIDocumentPickerDelegate
extension NotificationDetailPresenter {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        view?.showLoading()
        interactor.sendFile(self.notification!, urls)
    }
}

// MARK: - NotificationDetailPresenterInterface
extension NotificationDetailPresenter: NotificationDetailPresenterInterface {

    func didTapEdit() {
        if let notification = notification {
            wireframe.showEditNotificationScreen(notification)
        }
    }

    func didLongPressContent() {
        view?.showContentMenu()
    }

    func didTapCopyContent() {
        view?.copyToClipBoard(notification!.notification.attributes.content)
    }

    func didTapAttachment(_ data: AttachmentData) {
        if let url = data.url {
            wireframe.showAttachmentPreviewScreen(url)
        }
    }

    func didTapApproval() {
        if let notification = notification {
            wireframe.showConfirmAlert(
                nil,
                R.string.localizable.alertMessageConfirmApproval(),
                R.string.localizable.yes(), { [unowned self] in
                    self.interactor.approve(notification)
                },
                R.string.localizable.no(),
                nil
            )
        }
    }

    func didTapRemoveClap(_ comment: NotificationCommentData) {
        interactor.removeClap(notification!, comment)
    }

    func didTapAddClap(_ comment: NotificationCommentData) {
        interactor.addClap(notification!, comment)
    }

    func didTapFile() {
        view?.showDocumentPicker(avaiableExtensions.map { $0.key }, .import, true)
    }

    func didTapImage() {
        wireframe.showMediaPickerSelectActionSheet(self, view!, [kUTTypeImage, kUTTypeMovie])
    }

    func didTapSendMessage(_ content: String) {
        interactor.comment(notification!, content)
    }

    func didTapStamp(_ id: String) {
        interactor.sendStamp(notification!, id)
    }

    func didLongPress(_ comment: NotificationCommentData) {
        longPressedMessage = comment
        let loginUser = UserService.loginUser!
        view?.showMessageMenu(comment.sender.data.id != loginUser.data.id, comment.notificationComment.attributes.content != nil && comment.notificationComment.attributes.content!.count > 0)
    }

    func didTapReportMessage() {
        if let message = longPressedMessage {
            wireframe.showReportMessageScreen(notification!, message)
            longPressedMessage = nil
        }
    }

    func didTapCopyMessage() {
        if let message = longPressedMessage, let content = message.notificationComment.attributes.content {
            view?.copyToClipBoard(content)
        }
    }

    func didReachBottom() {
        if isFetching || currentPagenation?.next == nil {
            return
        }
        isFetching = true
        interactor.fetchComments(notification!, currentPagenation?.next)
    }
}

// MARK: - NotificationDetailInteractorOutputInterface
extension NotificationDetailPresenter: NotificationDetailInteractorOutputInterface {

    func didUpdated(_ notification: NotificationData) {
        payload = (loginUser, notification)
        view?.hideLoading()
        view?.reload(notification)
    }

    func fetchCommentsCompleted(_ comments: [NotificationCommentData], _ pagenation: Pagenation) {
        isFetching = false
        if currentPagenation == nil {
            view?.showComments(comments)
        } else {
            view?.showMoreComments(comments)
        }
        currentPagenation = pagenation
    }

    func commentCompleted(_ send: NotificationCommentData) {
        view?.hideLoading()
        view?.showSendComment(send)
    }
}
