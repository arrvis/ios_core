//
//  GroupChatTableViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit
import RxSwift
import TinyConstraints

final class GroupChatTableViewController: AppTableViewController {

    // MARK: - Variables

    var didMessagesDisplayed: Observable<[Message]> {
        return didMessagesDisplayedSubject
    }
    private let didMessagesDisplayedSubject = PublishSubject<[Message]>()

    var didReachTop: Observable<Void> {
        return didReachTopSubject
    }
    private let didReachTopSubject = PublishSubject<Void>()

    var didTapUser: Observable<String> {
        return didTapUserSubject
    }
    private let didTapUserSubject = PublishSubject<String>()

    var didTapRemoveClap: Observable<Message> {
        return didTapRemoveClapSubject
    }
    private let didTapRemoveClapSubject = PublishSubject<Message>()

    var didTapAddClap: Observable<Message> {
        return didTapAddClapSubject
    }
    private let didTapAddClapSubject = PublishSubject<Message>()

    var didLongPress: Observable<Message> {
        return didLongPressSubject
    }
    private let didLongPressSubject = PublishSubject<Message>()

    var didTapAttachment: Observable<AttachmentData> {
        return didTapAttachmentSubject
    }
    private let didTapAttachmentSubject = PublishSubject<AttachmentData>()

    private var loginUser: UserData!
    private var group: GroupData!
    private var messages = [Message]()
    private var readedMessageIds = [String]()
    private var dateGroupedMessages: ([Date], [Date: [Message]]) = ([], [:])

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.tableFooterView = UIView()
        tableView.register(R.nib.dateHeaderTableViewCell)
        tableView.register(R.nib.sentMessageTableViewCell)
        tableView.register(R.nib.receivedMessageTableViewCell)
    }

    // MARK: - Methods

    func showMessages(_ loginUser: UserData, _ group: GroupData, _ messages: [Message]) {
        self.loginUser = loginUser
        self.group = group
        self.messages = messages
        refreshMessages()
    }

    func showMoreMessages(_ loginUser: UserData, _ group: GroupData, _ messages: [Message]) {
        self.loginUser = loginUser
        self.group = group
        self.messages += messages
        self.messages = self.messages.distinct()
        refreshMessages()
    }

    private func refreshMessages() {
        dateGroupedMessages = toGrouped(messages)
        tableView.reloadData()
        if loginUser.role.isAdmin {
            return
        }
        // reloadDataの完了を待つ
        NSObject.runOnMainThread { [unowned self] in
            if let oldestUnreadMessage = self.filterUnreadMessages(self.messages).last {
                let indexPath = self.indexPathByMessage(oldestUnreadMessage)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                self.doMarkAsRead()
            }
        }
    }

    func showReceivedMessage(_ message: Message) {
        if let index = messages.firstIndex(of: message) {
            messages.remove(at: index)
        }
        messages.append(message)
        dateGroupedMessages = toGrouped(messages)
        tableView.reloadData()
    }

    func dismissMessage(_ message: Message) {
        if let index = messages.firstIndex(of: message) {
            messages.remove(at: index)
        }
        dateGroupedMessages = toGrouped(messages)
        tableView.reloadData()
    }

    // MARK: - Private

    private func toGrouped(_ messages: [Message]) -> ([Date], [Date: [Message]]) {
        let grouped = Dictionary(grouping: messages.sorted(by: { l, r -> Bool in
            return l.attributes.createdAt > r.attributes.createdAt
        }), by: { message -> Date in
            message.attributes.createdAtValue.startOfDay
        })
        return (grouped.keys.sorted(by: { $0 > $1}), grouped)
    }

    private func getDateMessages(_ index: Int) -> [Message] {
        let date = dateGroupedMessages.0[index]
        return dateGroupedMessages.1[date]!
    }

    private func messageByIndexPath(_ indexPath: IndexPath) -> Message {
        return getDateMessages(indexPath.section)[indexPath.row]
    }

    private func doMarkAsRead() {
        didMessagesDisplayedSubject.onNext(filterUnreadMessages(tableView.visibleCells.compactMap { ($0 as? ReceivedMessageTableViewCell)?.message }))
    }

    private func filterUnreadMessages(_ source: [Message]) -> [Message] {
        let loginUserId = Int(loginUser.data.id)!
        return source.filter { !$0.attributes.readerIds.contains(loginUserId) && !readedMessageIds.contains($0.id) && $0.attributes.userId != loginUserId }
    }

    private func indexPathByMessage(_ message: Message) -> IndexPath {
        let date = message.attributes.createdAtValue.startOfDay
        let section = dateGroupedMessages.0.firstIndex(of: message.attributes.createdAtValue.startOfDay)!
        let row = dateGroupedMessages.1[date]!.firstIndex {$0.id == message.id }!
        return IndexPath(row: row, section: section)
    }
}

// MARK: - UITableViewDataSource
extension GroupChatTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dateGroupedMessages.0.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDateMessages(section).count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > getDateMessages(indexPath.section).count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.dateHeaderTableViewCell, for: indexPath)!
            cell.refreshFontSize()
            cell.date = dateGroupedMessages.0[indexPath.section]
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
        let message = messageByIndexPath(indexPath)
        if message.attributes.userId == Int(loginUser.data.id) {
            // send
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sentMessageTableViewCell, for: indexPath)!
            cell.refreshFontSize()
            cell.message = message
            cell.didTapAttachment = { [unowned self] data in
                self.didTapAttachmentSubject.onNext(data)
            }
            cell.didLongPress = { [unowned self] in
                self.didLongPressSubject.onNext(message)
            }
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        } else {
            // received
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.receivedMessageTableViewCell, for: indexPath)!
            cell.refreshFontSize()
            cell.userIcon = group.users.first(where: { Int($0.data.id) == message.attributes.userId })?.data.attributes.icon
            cell.userName = message.getDisplayName(group)
            cell.message = message
            cell.isJoinedGroup = group.isJoined
            cell.isClapped = message.attributes.clapperIds.contains(where: { "\($0)" == loginUser.data.id })
            cell.didTapUser = { [unowned self] in
                self.didTapUserSubject.onNext(String(message.attributes.userId!))
            }
            cell.didTapRemoveClap = { [unowned self] in
                self.didTapRemoveClapSubject.onNext(message)
            }
            cell.didTapAddClap = { [unowned self] in
                self.didTapAddClapSubject.onNext(message)
            }
            cell.didLongPress = { [unowned self] in
                self.didLongPressSubject.onNext(message)
            }
            cell.didTapAttachment = { [unowned self] data in
                self.didTapAttachmentSubject.onNext(data)
            }
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
    }
}

// MARK: - UIScrollViewDelegate
extension GroupChatTableViewController {

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        doMarkAsRead()
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtBottom {
            didReachTopSubject.onNext(())
        }
    }
}

extension UIScrollView {

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
