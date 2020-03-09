//
//  GroupService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift
import ActionCableClient

/// グループサービス
final class GroupService {

    // MARK: - Variables

    static var currentEditedGroup: GroupData?

    // MARK: - Methods

    private struct GroupsResponse: BaseModel {
        let data: [ResponsedGroup]
    }
    /// グループ一覧の取得
    static func fetchGroups() -> Observable<[ResponsedGroup]> {
        let request: Observable<GroupsResponse> = APIRouter(path: "/groups?all=true").request()
        return request.map { ret -> [ResponsedGroup] in
            return ret.data
        }.retryAuth()
    }
    /// グループ一覧の取得 - 付属データつき
    static func fetchGroupsWithData() -> Observable<[GroupData]> {
        let request: Observable<GroupsResponse> = APIRouter(path: "/groups").request()
        return request.map { ret -> [ResponsedGroup] in
            return ret.data
        }.flatMap { ret -> Observable<[GroupData]> in
            if ret.isEmpty {
                return Observable.create { observer in
                    observer.onNext([])
                    return Disposables.create()
                }
            }
            return Observable.zip(ret.map { group in
                return fetchGroupUsers(group).map { users in
                    return GroupData(
                        group: group,
                        users: users.data.map { UserData(data: $0, included: users.included) },
                        isJoined: users.data.contains(where: { $0.id == UserService.loginUser?.data.id })
                    )
                }
            })
        }.retryAuth()
    }
    private struct GroupUsersResponse: BaseModel {
        let data: [UserRelation]
        let included: [Included]
    }
    private static func fetchGroupUsers(_ group: ResponsedGroup) -> Observable<GroupUsersResponse> {
        return APIRouter(path: "/groups/\(group.id)/users").request().retryAuth()
    }
}

/// グループ管理
extension GroupService {

    /// グループの新規作成
    static func createGroup(
        _ name: String,
        _ icon: UIImage?,
        _ members: [UserData]) -> Observable<Void> {
        struct Param: Codable {
            let group: Data
        }
        struct Data: Codable {
            let name: String
            let icon: String?
            let userIds: [Int]
            enum CodingKeys: String, CodingKey {
                case name
                case icon
                case userIds = "user_ids"
            }
        }
        let request: Observable<VoidResponse> = APIRouter(
            path: "/groups",
            httpMethod: .post,
            parameters: Param(group: Data(name: name, icon: icon?.resizeFit(minimumLength: 300).base64DataString, userIds: members.map { Int($0.data.id)! }))
        ).request()
        return request.map { _ in () }.retryAuth()
    }

    /// グループの更新
    static func editGroup(
        _ groupId: String,
        _ name: String,
        _ icon: UIImage?,
        _ members: [UserData]) -> Observable<GroupData> {
        struct Param: Codable {
            let group: Data
        }
        struct Data: Codable {
            let name: String
            let icon: String?
            let userIds: [Int]
            enum CodingKeys: String, CodingKey {
                case name
                case icon
                case userIds = "user_ids"
            }
        }

        let request: Observable<VoidResponse> = APIRouter(
            path: "/groups/\(groupId)",
            httpMethod: .patch,
            parameters: Param(group: Data(name: name, icon: icon?.resizeFit(minimumLength: 300).base64DataString, userIds: members.map { Int($0.data.id)! }))
          ).request()
        return request.flatMap { _ -> Observable<GroupData> in
            return fetchGroupsWithData().map { ret -> GroupData in
                currentEditedGroup = ret.first(where: { $0.group.id == groupId })!
                return currentEditedGroup!
            }
        }.retryAuth()
    }

    /// グループから退会
    static func leaveGroup(_ groupId: String) -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/groups/\(groupId)/users",
            httpMethod: .delete
        ).request()
        return request.map { _ in () }.retryAuth()
    }
}

// MARK: - メッセージ
extension GroupService {

    private struct GroupMessagesResponse: BaseModel {
        let data: [Message]
        let pagenation: Pagenation
    }
    /// そのグループのメッセージ一覧の取得
    static func fetchGroupMessages(_ group: ResponsedGroup, _ page: Int?) -> Observable<(data: [Message], pagenation: Pagenation)> {
        let param = page == nil ? "" : "?page=\(page!)"
        let request: Observable<GroupMessagesResponse> = APIRouter(path: "/groups/\(group.id)/messages\(param)").request()
        return request.map { (data: $0.data, pagenation: $0.pagenation) }.retryAuth()
    }

    private struct SendMessageResponse: BaseModel {
        let data: Message
    }
    /// そのグループへメッセージを投稿
    static func sendMessage(_ groupId: String, _ content: String) -> Observable<Message> {
        struct Param: Codable {
            let message: SendMessage
        }
        struct SendMessage: Codable {
            let content: String
        }
        let request: Observable<SendMessageResponse> = APIRouter(
            path: "/groups/\(groupId)/messages",
            httpMethod: .post,
            parameters: Param(message: SendMessage(content: content))
        ).request()
        return request.map { response in
            return response.data
        }.retryAuth()
    }
    /// そのグループへファイルを投稿
    static func sendFiles(_ groupId: String, _ files: [URL]) -> Observable<Message> {
        struct Param: Codable {
            let attachmentsAttributes: [Attatchment]
            enum CodingKeys: String, CodingKey {
                case attachmentsAttributes = "attachments_attributes"
            }
        }
        struct Attatchment: Codable {
            let name: String
            let file: String
        }
        let request: Observable<SendMessageResponse> = APIRouter(
            path: "/groups/\(groupId)/messages",
            httpMethod: .post,
            parameters: Param(attachmentsAttributes: files.compactMap {
                if let data = try? Data(contentsOf: $0),
                    let ext = $0.lastPathComponent.split(separator: ".").last,
                    let mimeType = String(ext).toMIMETypeFromExt() {
                    return Attatchment(
                        name: $0.lastPathComponent,
                        file: "data:\(mimeType);base64,\(data.base64EncodedString())"
                    )
                }
                return nil
            })
        ).request()
        return request.map { response in
            return response.data
        }.retryAuth()
    }
    /// そのグループへスタンプを送信
    static func sendStamp(_ groupId: String, _ id: String) -> Observable<Message> {
        struct Param: Codable {
            let message: Stamp
        }
        struct Stamp: Codable {
            let stamp: String
        }
        let request: Observable<SendMessageResponse> = APIRouter(
            path: "/groups/\(groupId)/messages",
            httpMethod: .post,
            parameters: Param(message: Stamp(stamp: id))
        ).request()
        return request.map { response in
            return response.data
        }.retryAuth()
    }

    /// メッセージの削除
    static func deleteMessage(_ groupId: String, _ messageId: String) -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/groups/\(groupId)/messages/\(messageId)",
            httpMethod: .delete
        ).request()
        return request.map { _ in () }.retryAuth()
    }

    /// メッセージへの拍手
    static func sendClap(_ groupId: String, _ messageId: String) -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/groups/\(groupId)/messages/\(messageId)/clappers",
            httpMethod: .post
        ).request()
        return request.map { _ in () }.retryAuth()
    }

    /// メッセージへの拍手とりやめ
    static func deleteClap(_ groupId: String, _ messageId: String) -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/groups/\(groupId)/messages/\(messageId)/clappers",
            httpMethod: .delete
        ).request()
        return request.map { _ in () }.retryAuth()
    }

    /// メッセージの既読
    static func markAsRead(_ groupId: String, _ messageId: String) -> Observable<[Int]> {
        return APIRouter(
            path: "/groups/\(groupId)/messages/\(messageId)/readers",
            httpMethod: .post
        ).request()
    }

    private static var subscribers = [(String, ActionCableClient)]()
    /// グループメッセージのsubscribe
    static func subscribeGroupMessage(_ group: GroupData, _ didMessageReceive: @escaping (Message) -> Void) {
        let client = ActionCableClient(url: URL(string: webSocketURL)!)
        client.headers = APIRouter.additionalHeaders
        client.connect()
        client.onConnected = {
            let channel = client.create("GroupChannel", parameters: ChannelParameters(dictionaryLiteral: ("group_id", Int(group.group.id)!)))
            channel.onReceive = { (data: Any?, error: Error?) in
                if let json = data as? String {
                    struct Res: BaseModel {
                        let data: Message
                    }
                    didMessageReceive(Res.fromJson(json).data)
                }
            }
        }
        subscribers.append((group.group.id, client))
    }
    /// グループメッセージのunsubscribe
    static func unsubscribeGroupMessage(_ group: GroupData) {
        if let data = subscribers.first(where: { $0.0 == group.group.id }) {
            data.1.disconnect()
            subscribers.removeAll(where: { $0.0 == group.group.id })
        }
    }
}
