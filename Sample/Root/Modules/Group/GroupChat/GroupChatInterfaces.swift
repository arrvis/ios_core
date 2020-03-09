//
//  GroupChatInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol GroupChatViewInterface: ViewInterface {
    func showGroup(_ group: GroupData)
    func showMessages(_ loginUser: UserData, _ group: GroupData, _ messages: [Message])
    func showMoreMessages(_ loginUser: UserData, _ group: GroupData, _ messages: [Message])
    func showReceivedMessage(_ message: Message)
    func showMessageMenu(_ canReport: Bool, _ canCopy: Bool, _ canDelete: Bool)
    func copyToClipBoard(_ text: String)
    func dismissMessage(_ message: Message)
}

protocol GroupChatPresenterInterface: PresenterInterface {
    func didTapMenu()
    func didTapRemoveClap(_ message: Message)
    func didTapAddClap(_ message: Message)
    func didLongPress(_ message: Message)
    func didTapReportMessage()
    func didTapCopyMessage()
    func didTapDeleteMessage()
    func didTapAttachment(_ data: AttachmentData)
    func didTapFile()
    func didTapImage()
    func didTapSendMessage(_ content: String)
    func didTapStamp(_ id: String)
    func didMessagesDisplayed(_ messages: [Message])
    func didReachTop()
}

protocol GroupChatInteractorInterface: InteractorInterface {
    func fetchMessages(_ group: GroupData, _ page: Int?)
    func removeClap(_ group: GroupData, _ message: Message)
    func sendClap(_ group: GroupData, _ message: Message)
    func sendFiles(_ group: GroupData, _ files: [URL])
    func sendMessage(_ group: GroupData, _ content: String)
    func sendStamp(_ group: GroupData, _ id: String)
    func subscribe(_ group: GroupData)
    func unsubscribe(_ group: GroupData)
    func markAsRead(_ group: GroupData, _ messages: [Message])
    func deleteMessage(_ group: GroupData, _ message: Message)
}

protocol GroupChatInteractorOutputInterface: InteractorOutputInterface {
    func fetchMeesagesCompleted(_ loginUser: UserData, _ messages: [Message], _ pagenation: Pagenation)
    func onMessageReceived(_ message: Message)
    func deleteMessageCompleted(_ message: Message)
}

protocol GroupChatWireframeInterface: WireframeInterface {
    func showGroupSettingScreen(_ group: GroupData)
    func showReportMessageScreen(_ group: GroupData, _ message: Message)
}
