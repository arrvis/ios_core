//
//  NotificationDetailViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 27/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit
import RxCocoa

// MARK: - NotificationDetailViewController
final class NotificationDetailViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var bottomOfInput: NSLayoutConstraint!
    @IBOutlet weak private var messageInputView: MessageInputView!

    // MARK: - Variables

    private var presenter: NotificationDetailPresenterInterface {
        return presenterInterface as! NotificationDetailPresenterInterface
    }

    private var tableViewController: NotificationDetailTableViewController!

    // MARK: - Overrides

    override func onKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        bottomOfInput.constant = keyboardFrame.height
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
        messageInputView.onKeyboardWillShow()
    }

    override func onKeyboardWillHide(notification: Notification) {
        bottomOfInput.constant = safeAreaInsets?.bottom ?? 0
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutIfNeeded()
        }
        messageInputView.onKeyboardWillHide()
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = R.string.localizable.notificationDetail()
        messageInputView.didTapFile.subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
            self.presenter.didTapFile()
        }).disposed(by: self)
        messageInputView.didTapImage.subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
            self.presenter.didTapImage()
        }).disposed(by: self)
        messageInputView.didTapSend.subscribe(onNext: { [unowned self] text in
           self.view.endEditing(true)
           self.presenter.didTapSendMessage(text)
       }).disposed(by: self)
        messageInputView.didTapStamp.subscribe(onNext: { [unowned self] id in
            self.presenter.didTapStamp(id)
        }).disposed(by: self)
    }

    override func onDidFirstLayoutSubviews() {
        super.onDidFirstLayoutSubviews()
        bottomOfInput.constant = safeAreaInsets?.bottom ?? 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotificationDetailTableViewController {
            tableViewController = vc
            vc.didLongPressContent.subscribe(onNext: { [unowned self] _ in
                self.presenter.didLongPressContent()
            }).disposed(by: self)
            vc.didTapApproval.subscribe(onNext: { [unowned self] _ in
                self.presenter.didTapApproval()
            }).disposed(by: self)
            vc.didReachBottom.subscribe(onNext: { [unowned self] _ in
                self.presenter.didReachBottom()
            }).disposed(by: self)
            vc.didTapUser.subscribe(onNext: { [unowned self] userId in
                self.presenter.didTapUser(userId)
            }).disposed(by: self)
            vc.didTapRemoveClap.subscribe(onNext: { [unowned self] comment in
                self.presenter.didTapRemoveClap(comment)
            }).disposed(by: self)
            vc.didTapAddClap.subscribe(onNext: { [unowned self] comment in
                self.presenter.didTapAddClap(comment)
            }).disposed(by: self)
            vc.didLongPress.subscribe(onNext: { [unowned self] comment in
                self.presenter.didLongPress(comment)
            }).disposed(by: self)
            vc.didTapAttachment.subscribe(onNext: { [unowned self] url in
                self.presenter.didTapAttachment(url)
            }).disposed(by: self)
            vc.tableView.addGestureRecognizer({
                let tap = UITapGestureRecognizer(target: self, action: #selector(anAction))
                tap.cancelsTouchesInView = false
                return tap
            }())
        }
    }

    @objc func anAction() {
        view.endEditing(true)
        messageInputView.mode = .initial
    }
}

// MARK: - NotificationDetailViewInterface
extension NotificationDetailViewController: NotificationDetailViewInterface {

    func showNotification(_ loginUser: UserData, _ notification: NotificationData) {
        tableViewController.showNotification(loginUser, notification)
        if notification.sender.data == loginUser.data {
            navigationItem.rightBarButtonItems = [
                {
                    let item = UIBarButtonItem(title: R.string.localizable.edit(), style: .plain)
                    item.rx.tap.subscribe(onNext: { [unowned self] _ in
                        self.presenter.didTapEdit()
                    }).disposed(by: self)
                    return item
                }()
            ]
            configureNavigationItem()
        }
    }

    func reload(_ notification: NotificationData) {
        tableViewController.reload(notification)
    }

    func showComments(_ comments: [NotificationCommentData]) {
        tableViewController.showComments(comments)
    }

    func showMoreComments(_ comments: [NotificationCommentData]) {
        tableViewController.showMoreComments(comments)
    }

    func showSendComment(_ comment: NotificationCommentData) {
        tableViewController.showSendComment(comment)
    }

    func showContentMenu() {
        self.showActionSheet(nil, nil, [
            UIAlertAction(title: R.string.localizable.copy(), style: .default, handler: { [unowned self] _ in
                self.presenter.didTapCopyContent()
            })
        ], R.string.localizable.cancel(), nil)
    }

    func showMessageMenu(_ canReport: Bool, _ canCopy: Bool) {
        let actions: [UIAlertAction] = {
            var actions = [UIAlertAction]()
            if canCopy {
                actions.append(UIAlertAction(title: R.string.localizable.copy(), style: .default, handler: { [unowned self] _ in
                    self.presenter.didTapCopyMessage()
                }))
            }
            if canReport {
                actions.append(UIAlertAction(title: R.string.localizable.report(), style: .destructive, handler: { [unowned self] _ in
                    self.presenter.didTapReportMessage()
                }))
            }
            return actions
        }()
        self.showActionSheet(nil, nil, actions, R.string.localizable.cancel(), nil)
    }

    func copyToClipBoard(_ text: String) {
        UIPasteboard.general.string = text
        showOkAlert(nil, R.string.localizable.alertMessageDoneCopy(), nil, {})
    }
}
