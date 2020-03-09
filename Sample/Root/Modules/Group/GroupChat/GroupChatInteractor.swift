//
//  GroupChatInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupChatInteractor
final class GroupChatInteractor {

    // MARK: - Variables

    weak var output: GroupChatInteractorOutputInterface?

    private var isFirstLoad = true
    private var previousLoads = [Message]()
}

// MARK: - GroupChatInteractorInterface
extension GroupChatInteractor: GroupChatInteractorInterface {

    func fetchMessages(_ group: GroupData, _ page: Int?) {
        GroupService.fetchGroupMessages(group.group, page).subscribe(onNext: { [unowned self] response in
            let loginUser = UserService.loginUser!
            // 初回読み込み・最古の既読まで遡る
            if self.isFirstLoad,
                !response.data.contains { $0.attributes.readerIds.contains(Int(loginUser.data.id)!) && $0.attributes.userId != Int(loginUser.data.id)! },
                let next = response.pagenation.next {
                self.previousLoads.append(contentsOf: response.data)
                self.fetchMessages(group, next)
            } else {
                self.previousLoads.append(contentsOf: response.data)
                self.output?.fetchMeesagesCompleted(loginUser, self.previousLoads, response.pagenation)
                self.previousLoads.removeAll()
            }
            self.isFirstLoad = false
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func removeClap(_ group: GroupData, _ message: Message) {
        GroupService.deleteClap(group.group.id, message.id).subscribe(onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func sendClap(_ group: GroupData, _ message: Message) {
        GroupService.sendClap(group.group.id, message.id).subscribe(onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func sendFiles(_ group: GroupData, _ files: [URL]) {
        GroupService.sendFiles(group.group.id, files).subscribe(onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func sendMessage(_ group: GroupData, _ content: String) {
        GroupService.sendMessage(group.group.id, content).subscribe(onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func sendStamp(_ group: GroupData, _ id: String) {
        GroupService.sendStamp(group.group.id, id).subscribe(onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }

    func subscribe(_ group: GroupData) {
        GroupService.subscribeGroupMessage(group) { [unowned self] message in
            self.output?.onMessageReceived(message)
        }
    }

    func unsubscribe(_ group: GroupData) {
        GroupService.unsubscribeGroupMessage(group)
    }

    func markAsRead(_ group: GroupData, _ messages: [Message]) {
        if messages.isEmpty {
            return
        }
        if !group.isJoined {
            return
        }
        // 既読は一番新しいやつを投げればよい
        if let oldestUnread = messages.filter({ message -> Bool in
            return !message.attributes.readerIds.contains(Int(UserService.loginUser!.data.id)!)
        }).sorted(by: { l, r -> Bool in
            return l.attributes.createdAtValue > r.attributes.createdAtValue
        }).first {
            GroupService.markAsRead(group.group.id, oldestUnread.id).subscribe(onNext: { [unowned self] _ in
                messages.forEach { [unowned self] message in
                    self.output?.onMessageReceived(message.markAsRead(by: UserService.loginUser!))
                }
            }, onError: { [unowned self] error in
                self.output?.handleError(error, nil)
            }).disposed(by: self)
        }
    }

    func deleteMessage(_ group: GroupData, _ message: Message) {
        GroupService.deleteMessage(group.group.id, message.id).subscribe(onNext: { [unowned self] _ in
            self.output?.deleteMessageCompleted(message)
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)
    }
}
