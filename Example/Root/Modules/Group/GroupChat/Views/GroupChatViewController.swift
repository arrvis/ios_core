//
//  GroupChatViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit
import RxGesture

// MARK: - GroupChatViewController
final class GroupChatViewController: ViewBase {

    // MARK: - Outlets

    @IBOutlet weak private var bottomOfInput: NSLayoutConstraint!
    @IBOutlet weak private var messageInputView: MessageInputView!

    // MARK: - Variables

    private var presenter: GroupChatPresenterInterface {
        return presenterInterface as! GroupChatPresenterInterface
    }

    private var tableViewController: GroupChatTableViewController!

    // MARK: - Overrides

    override var rightBarButtonItems: [UIBarButtonItem]? {
        return [
            UIBarButtonItem(image: R.image.iconHamburger()!, style: .plain)
        ]
    }

    override func didTapRightBarButtonItem(_ index: Int) {
        presenter.didTapMenu()
    }

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
        if let vc = segue.destination as? GroupChatTableViewController {
            tableViewController = vc
            vc.didMessagesDisplayed.subscribe(onNext: { [unowned self] messages in
                self.presenter.didMessagesDisplayed(messages)
            }).disposed(by: self)
            vc.didReachTop.subscribe(onNext: { [unowned self] _ in
                self.presenter.didReachTop()
            }).disposed(by: self)
            vc.didTapUser.subscribe(onNext: { [unowned self] userId in
                self.presenter.didTapUser(userId)
            }).disposed(by: self)
            vc.didTapRemoveClap.subscribe(onNext: { [unowned self] message in
                self.presenter.didTapRemoveClap(message)
            }).disposed(by: self)
            vc.didTapAddClap.subscribe(onNext: { [unowned self] message in
                self.presenter.didTapAddClap(message)
            }).disposed(by: self)
            vc.didLongPress.subscribe(onNext: { [unowned self] message in
                self.presenter.didLongPress(message)
            }).disposed(by: self)
            vc.didTapAttachment.subscribe(onNext: { [unowned self] message in
                self.presenter.didTapAttachment(message)
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

// MARK: - GroupChatViewInterface
extension GroupChatViewController: GroupChatViewInterface {

    func showGroup(_ group: GroupData) {
        title = group.group.groupNameLabelText
    }

    func showMessages(_ loginUser: UserData, _ group: GroupData, _ messages: [Message]) {
        tableViewController.showMessages(loginUser, group, messages)
    }

    func showMoreMessages(_ loginUser: UserData, _ group: GroupData, _ messages: [Message]) {
        tableViewController.showMoreMessages(loginUser, group, messages)
    }

    func showReceivedMessage(_ message: Message) {
        tableViewController.showReceivedMessage(message)
    }

    func showMessageMenu(_ canReport: Bool, _ canCopy: Bool, _ canDelete: Bool) {
        let actions: [UIAlertAction] = {
            var actions = [UIAlertAction]()
            if canCopy {
                actions.append(UIAlertAction(title: R.string.localizable.copy(), style: .default, handler: { [unowned self] _ in
                    self.presenter.didTapCopyMessage()
                }))
            }
            if canDelete {
                actions.append(UIAlertAction(title: R.string.localizable.delete(), style: .destructive, handler: { [unowned self] _ in
                    self.presenter.didTapDeleteMessage()
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

    func dismissMessage(_ message: Message) {
        tableViewController.dismissMessage(message)
    }
}
