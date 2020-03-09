//
//  NotificationCreationPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import MobileCoreServices

// MARK: - NotificationCreationPresenter
final class NotificationCreationPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: NotificationCreationInteractorInterface {
        return interactorInterface as! NotificationCreationInteractorInterface
    }

    private weak var view: NotificationCreationViewInterface? {
        return viewInterface as? NotificationCreationViewInterface
    }

    private var wireframe: NotificationCreationWireframeInterface {
        return wireframeInterface as! NotificationCreationWireframeInterface
    }

    private var original: NotificationData? {
        return payload as? NotificationData
    }
    private var selectedGroups = [ResponsedGroup]()
    private var selectedAttachments = [AttachmentData]()
    private var approvalConfirmation: String? {
        didSet {
            view?.showApprovalConfirmation(approvalConfirmation)
        }
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if original != nil {
            view?.showLoading()
            interactor.fetchGroups()
        }
    }

    override func onBackFromNext(_ result: Any?) {
        if let result = result as? ([ResponsedGroup], Int) {
            selectedGroups = result.0
            view?.showSelectedGroups(result.0, result.1)
        } else if let result = result as? String? {
            approvalConfirmation = result
        }
    }

    // MARK: - CameraRollEventHandler

    override func onImageSelected(_ image: UIImage, _ info: [UIImagePickerController.InfoKey: Any]) {
        if let url = info[.imageURL] as? URL {
            addToSelectedAttachment(url)
        } else {
            let directory = NSTemporaryDirectory()
            let fileName = "\(NSUUID().uuidString).png"
            let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])!
            if (try? image.pngData()?.write(to: fullURL)) != nil {
                addToSelectedAttachment(fullURL)
            }
        }
    }

    override func onMediaSelected(_ url: URL, _ info: [UIImagePickerController.InfoKey: Any]) {
        addToSelectedAttachment(url)
    }

    // MARK: - Private

    private func addToSelectedAttachment(_ url: URL) {
        let data = AttachmentData(id: nil, name: url.lastPathComponent, url: url, canDelete: true, canSelect: true)
        selectedAttachments.append(data)
        view?.showSelectedAttachment(data)
    }
}

// MARK: - UIDocumentPickerDelegate
extension NotificationCreationPresenter {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        urls.forEach { [unowned self] url in
            self.addToSelectedAttachment(url)
        }
    }
}

// MARK: - NotificationCreationPresenterInterface
extension NotificationCreationPresenter: NotificationCreationPresenterInterface {

    func didTapPost(
        _ title: String,
        _ content: String,
        _ isRequiredApproval: Bool,
        _ approvingDeadline: Date?,
        _ isRequiredRead: Bool) {
        view?.showLoading()
        interactor.post(
            original,
            selectedGroups,
            title,
            content,
            selectedAttachments,
            isRequiredApproval,
            approvalConfirmation,
            approvingDeadline,
            isRequiredRead
        )
    }

    func didTapSelectGroup() {
        wireframe.showSelectGroupScreen(selectedGroups)
    }

    func didTapAddFile() {
        view?.showDocumentPicker(avaiableExtensions.map { $0.key }, .import, false)
    }

    func didTapAddImage() {
        wireframe.showMediaPickerSelectActionSheet(self, view!, [kUTTypeImage, kUTTypeMovie])
    }

    func didTapAttachment(_ data: AttachmentData) {
        if let url = data.url {
            wireframe.showAttachmentPreviewScreen(url, false)
        }
    }

    func didTapRemoveFile(_ data: AttachmentData) {
        selectedAttachments.removeAll(where: { $0 == data })
    }

    func didTapApprovalConfirmation() {
        wireframe.showEditApprovalConfirmationScreen(approvalConfirmation)
    }
}

// MARK: - NotificationCreationInteractorOutputInterface
extension NotificationCreationPresenter: NotificationCreationInteractorOutputInterface {

    func fetchGroupsCompleted(_ groups: [ResponsedGroup]) {
        view?.hideLoading()
        if let original = original {
            selectedGroups = original.notification.relationships.groups.data.map { data in groups.first(where: { $0.id == data.id })! }
            view?.showSelectedGroups(selectedGroups, groups.count)
            selectedAttachments = original.notification.attributes.attachments.map {
                AttachmentData(
                    id: $0.id,
                    name: $0.name,
                    url: $0.url == nil ? nil : URL(string: $0.url!),
                    canDelete: true,
                    canSelect: true)
            }
            selectedAttachments.forEach { attachment in
                view?.showSelectedAttachment(attachment)
            }
            approvalConfirmation = original.notification.attributes.approvalConfirmation
            view?.showEditData(original)
        }
    }

    func postCompleted(_ posted: ResponsedNotification) {
        view?.hideLoading()
        wireframe.dismissScreen(result: posted)
    }
}
