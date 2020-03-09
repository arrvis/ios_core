//
//  NotificationCreationViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - NotificationCreationViewController
final class NotificationCreationViewController: ViewBase {

    // MARK: - Variables

    private var presenter: NotificationCreationPresenterInterface {
        return presenterInterface as! NotificationCreationPresenterInterface
    }

    private var tableViewController: NotificationCreationTableViewController!

    // MARK: - Overrides

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapPost(
            tableViewController.notificationTitle,
            tableViewController.notificationContent,
            tableViewController.isRequiredApproval,
            tableViewController.approvingDeadline,
            tableViewController.isRequiredRead)
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.notificationCreation()
        configureRightItemsToBlue()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotificationCreationTableViewController {
            tableViewController = vc
            vc.didTapSelectGroup.subscribe(onNext: { [unowned self] _ in
                self.presenter.didTapSelectGroup()
            }).disposed(by: self)
            vc.didTapAddFiles.subscribe(onNext: { [unowned self] _ in
                self.presenter.didTapAddFile()
            }).disposed(by: self)
            vc.didTapAddImage.subscribe(onNext: { [unowned self] _ in
                self.presenter.didTapAddImage()
            }).disposed(by: self)
            vc.didTapAttachment.subscribe(onNext: { [unowned self] url in
                self.presenter.didTapAttachment(url)
            }).disposed(by: self)
            vc.didTapRemoveAttachment.subscribe(onNext: { [unowned self] attachment in
                self.presenter.didTapRemoveFile(attachment)
            }).disposed(by: self)
            vc.didTapApprovalConfirmation.subscribe(onNext: { [unowned self] _ in
                self.presenter.didTapApprovalConfirmation()
            }).disposed(by: self)
            vc.didInputDataChanged.subscribe(onNext: { [unowned self] _ in
                self.rightBarButtonItems?.forEach { item in
                    item.isEnabled = !vc.selectedGroups.isEmpty
                        && !vc.notificationTitle.isEmpty
                        && !vc.notificationContent.isEmpty
                        && (!vc.isRequiredApproval || vc.approvalConfirmation?.isEmpty == false)
                }
            }).disposed(by: self)
        }
    }
}

// MARK: - NotificationCreationViewInterface
extension NotificationCreationViewController: NotificationCreationViewInterface {

    func showEditData(_ data: NotificationData) {
        tableViewController.showEditData(data)
    }

    func showSelectedGroups(_ groups: [ResponsedGroup], _ allGroupsCount: Int) {
        tableViewController.showSelectedGroups(groups, allGroupsCount)
    }

    func showSelectedAttachment(_ data: AttachmentData) {
        tableViewController.showSelectedAttachment(data)
    }

    func showApprovalConfirmation(_ approvalConfirmation: String?) {
        tableViewController.showApprovalConfirmation(approvalConfirmation)
    }
}
