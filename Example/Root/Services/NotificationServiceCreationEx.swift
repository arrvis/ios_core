//
//  NotificationServiceCreationEx.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/21.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift

// MARK: - 作成・編集
extension NotificationsService {

    /// お知らせの新規作成 / 編集
    static func postNotification(
        _ original: NotificationData?,
        _ groups: [ResponsedGroup],
        _ title: String,
        _ content: String,
        _ attachments: [AttachmentData],
        _ isRequiredApproval: Bool,
        _ approvalConfirmation: String?,
        _ approvingDeadline: Date?,
        _ isRequiredRead: Bool) -> Observable<ResponsedNotification> {
        struct Param: Codable {
            let notification: NData
        }
        struct NData: Codable {
            let title: String
            let content: String
            let isRequiredRead: Bool
            let isRequiredApproval: Bool
            let approvalConfirmation: String?
            let approvingDeadlineAt: String?
            let target: Int
            let status: Int
            let groupIds: [Int]
            let attachmentsAttributes: [AttachmentParam]

            enum CodingKeys: String, CodingKey {
                case title
                case content
                case isRequiredRead = "is_required_read"
                case isRequiredApproval = "is_required_approval"
                case approvalConfirmation = "approval_confirmation"
                case approvingDeadlineAt = "approving_deadline_at"
                case target
                case status
                case groupIds = "group_ids"
                case attachmentsAttributes = "attachments_attributes"
            }
        }
        struct AttachmentParam: BaseModel {
            let id: Int?
            let destroy: Int?
            let name: String?
            let file: String?
            enum CodingKeys: String, CodingKey {
                case id
                case destroy = "_destroy"
                case name
                case file
            }
        }
        var attachmentParams = [AttachmentParam]()
        if let original = original {
            // 削除されたもの
            attachmentParams = original.notification.attributes.attachments
                .filter { originalAttachment in !attachments.contains(where: { $0 == originalAttachment }) }
                .map { AttachmentParam(id: $0.id, destroy: 1, name: nil, file: nil) }
            // 追加されたもの
            attachmentParams.append(contentsOf:
                attachments
                    .filter { attachment in !original.notification.attributes.attachments.contains(where: { attachment == $0 }) }
                    .compactMap {
                        if let url = $0.url,
                            let data = try? Data(contentsOf: url),
                            let ext = url.lastPathComponent.split(separator: ".").last,
                            let mimeType = String(ext).toMIMETypeFromExt() {
                            return AttachmentParam(
                                id: nil,
                                destroy: nil,
                                name: url.lastPathComponent,
                                file: "data:\(mimeType);base64,\(data.base64EncodedString())"
                            )
                        }
                        return nil
                    }
            )
        } else {
            attachmentParams = attachments.compactMap {
                if let url = $0.url,
                    let data = try? Data(contentsOf: url),
                    let ext = url.lastPathComponent.split(separator: ".").last,
                    let mimeType = String(ext).toMIMETypeFromExt() {
                    return AttachmentParam(
                        id: nil,
                        destroy: nil,
                        name: url.lastPathComponent,
                        file: "data:\(mimeType);base64,\(data.base64EncodedString())"
                    )
                }
                return nil
            }
        }
        let param = Param(
            notification: NData(
            title: title,
            content: content,
            isRequiredRead: isRequiredRead,
            isRequiredApproval: isRequiredApproval,
            approvalConfirmation: approvalConfirmation,
            approvingDeadlineAt: approvingDeadline?.toString("yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"),
            target: groups.isEmpty ? 1 : 0,
            status: 1,
            groupIds: groups.map { Int($0.id)! },
            attachmentsAttributes: attachmentParams
        ))
        struct Response: BaseModel {
            let data: ResponsedNotification
        }
        if let original = original {
            let request: Observable<Response> = APIRouter(path: "/notifications/\(original.notification.id)", httpMethod: .patch, parameters: param).request()
            return request.map { $0.data }.retryAuth()
        } else {
            let request: Observable<Response> = APIRouter(path: "/notifications", httpMethod: .post, parameters: param).request()
            return request.map { $0.data }.retryAuth()
        }
    }
}
