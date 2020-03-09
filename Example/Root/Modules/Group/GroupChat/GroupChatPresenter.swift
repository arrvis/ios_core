//
//  GroupChatPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import MobileCoreServices

// MARK: - GroupChatPresenter
final class GroupChatPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: GroupChatInteractorInterface {
        return interactorInterface as! GroupChatInteractorInterface
    }

    private weak var view: GroupChatViewInterface? {
        return viewInterface as? GroupChatViewInterface
    }

    private var wireframe: GroupChatWireframeInterface {
        return wireframeInterface as! GroupChatWireframeInterface
    }

    private var group: GroupData {
        return payload as! GroupData
    }

    private var loginUser: UserData!
    private var currentPagenation: Pagenation?
    private var isFetching = false
    private var longPressedMessage: Message?

    // MARK: Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showGroup(group)
        interactor.fetchMessages(group, nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let edited = GroupService.currentEditedGroup {
            payload = edited
            GroupService.currentEditedGroup = nil
            view?.showGroup(group)
            interactor.fetchMessages(group, nil)
        }
        interactor.subscribe(group)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.unsubscribe(group)
    }

    // MARK: - CameraRollEventHandler

    override func onImageSelected(_ image: UIImage, _ info: [UIImagePickerController.InfoKey: Any]) {
        if let url = info[.imageURL] as? URL {
            view?.showLoading()
            interactor.sendFiles(group, [url])
        } else {
            view?.showLoading()
            let directory = NSTemporaryDirectory()
            let fileName = "\(NSUUID().uuidString).png"
            let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])!
            if (try? image.pngData()?.write(to: fullURL)) != nil {
                interactor.sendFiles(group, [fullURL])
            }
        }
    }

    override func onMediaSelected(_ url: URL, _ info: [UIImagePickerController.InfoKey: Any]) {
        view?.showLoading()
        interactor.sendFiles(group, [url])
    }
}

// MARK: - GroupChatPresenterInterface
extension GroupChatPresenter: GroupChatPresenterInterface {

    func didTapMenu() {
        wireframe.showGroupSettingScreen(group)
    }

    func didTapRemoveClap(_ message: Message) {
        interactor.removeClap(group, message)
    }

    func didTapAddClap(_ message: Message) {
        interactor.sendClap(group, message)
    }

    func didLongPress(_ message: Message) {
        longPressedMessage = message
        let isMyMessage = message.attributes.userId == Int(loginUser.data.id)
        view?.showMessageMenu(!isMyMessage, message.attributes.attachments.isEmpty, loginUser.role.isAdmin || isMyMessage)
    }

    func didTapReportMessage() {
        if let message = longPressedMessage {
            wireframe.showReportMessageScreen(group, message)
            longPressedMessage = nil
        }
    }

    func didTapCopyMessage() {
        if let message = longPressedMessage, let content = message.attributes.content {
            view?.copyToClipBoard(content)
        }
    }

    func didTapDeleteMessage() {
        if let message = longPressedMessage {
            view?.showLoading()
            interactor.deleteMessage(group, message)
        }
    }

    func didTapAttachment(_ data: AttachmentData) {
        if let url = data.url {
            wireframe.showAttachmentPreviewScreen(url)
        }
    }

    func didTapFile() {
        view?.showDocumentPicker(avaiableExtensions.map { $0.key }, .import, false)
    }

    func didTapImage() {
        wireframe.showMediaPickerSelectActionSheet(self, view!, [kUTTypeImage, kUTTypeMovie])
    }

    func didTapSendMessage(_ content: String) {
        interactor.sendMessage(group, content)
    }

    func didTapStamp(_ id: String) {
        interactor.sendStamp(group, id)
    }

    func didMessagesDisplayed(_ messages: [Message]) {
        interactor.markAsRead(group, messages)
    }

    func didReachTop() {
        if isFetching || currentPagenation?.next == nil {
            return
        }
        isFetching = true
        interactor.fetchMessages(group, currentPagenation?.next)
    }
}

// MARK: - UIDocumentPickerDelegate
extension GroupChatPresenter {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        view?.showLoading()
        interactor.sendFiles(group, urls)
    }
}

// MARK: - GroupChatInteractorOutputInterface
extension GroupChatPresenter: GroupChatInteractorOutputInterface {

    func fetchMeesagesCompleted(_ loginUser: UserData, _ messages: [Message], _ pagenation: Pagenation) {
        isFetching = false
        self.loginUser = loginUser
        if currentPagenation == nil {
            view?.showMessages(loginUser, group, messages)
        } else {
            view?.showMoreMessages(loginUser, group, messages)
        }
        currentPagenation = pagenation
    }

    func onMessageReceived(_ message: Message) {
        view?.hideLoading()
        view?.showReceivedMessage(message)
    }

    func deleteMessageCompleted(_ message: Message) {
        view?.hideLoading()
        view?.dismissMessage(message)
    }
}
