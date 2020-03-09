//
//  NotificationService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/01/16.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift

/// お知らせサービス
final class NotificationsService {

    private struct NotificationsResponse: BaseModel {
        let data: [ResponsedNotification]
        let included: [Included]
    }
    /// お知らせ一覧の取得
    static func fetchNotifications() -> Observable<[NotificationData]> {
        let request: Observable<NotificationsResponse> = APIRouter(path: "/notifications").request()
        return request.map { response -> [NotificationData] in
            return response.data.map { data -> NotificationData in
                return NotificationData(notification: data, included: response.included)
            }
        }.retryAuth()
    }

    /// お知らせに対する既読
    static func markAsRead(_ notificationId: String) -> Observable<NotificationData> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/notifications/\(notificationId)/readers",
            httpMethod: .post).request()
        return request.flatMap { _ in
            return fetchNotification(notificationId)
        }.retryAuth()
    }

    /// お知らせに対するis_approvedの更新
    static func approve(_ notificationId: String) -> Observable<NotificationData> {
        struct Param: Codable {
            let notificationReader: Reader
            enum CodingKeys: String, CodingKey {
                case notificationReader = "notification_reader"
            }
        }
        struct Reader: Codable {
            let isApproved = true
            enum CodingKeys: String, CodingKey {
                case isApproved = "is_approved"
            }
        }
        let request: Observable<VoidResponse> = APIRouter(
            path: "/notifications/\(notificationId)/readers",
            httpMethod: .patch,
            parameters: Param(notificationReader: Reader())).request()
        return request.flatMap { _ in
            return fetchNotification(notificationId)
        }.retryAuth()
    }

    private static func fetchNotification(_ notificationId: String) -> Observable<NotificationData> {
        struct Response: BaseModel {
            let data: ResponsedNotification
            let included: [Included]
        }
        let request: Observable<Response> = APIRouter(path: "/notifications/\(notificationId)").request()
        return request.map { ret -> NotificationData in
            return NotificationData(notification: ret.data, included: ret.included)
        }.retryAuth()
    }
}

// MARK: - コメント
extension NotificationsService {

    /// お知らせに対するコメント一覧の取得
    static func fetchComments(_ notificationId: String, _ page: Int?) -> Observable<([NotificationCommentData], Pagenation)> {
        struct Response: BaseModel {
            let data: [ResponsedNotificationComment]
            let included: [Included]
            let pagenation: Pagenation
        }
        let param = page == nil ? "" : "?page=\(page!)"
        let request: Observable<Response> = APIRouter(path: "/notifications/\(notificationId)/notification_comments\(param)").request()
        return request.map { ret -> ([NotificationCommentData], Pagenation) in
            return (ret.data.map { comment -> NotificationCommentData in
                return NotificationCommentData(notificationComment: comment, included: ret.included)
            }, ret.pagenation)
        }.retryAuth()
    }

    /// コメントへの拍手
    static func sendClap(_ notificationId: String, _ commentId: String) -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/notifications/\(notificationId)/notification_comments/\(commentId)/clappers",
            httpMethod: .post
        ).request()
        return request.map { _ in () }.retryAuth()
    }

    /// コメントへの拍手とりやめ
    static func deleteClap(_ notificationId: String, _ commentId: String) -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/notifications/\(notificationId)/notification_comments/\(commentId)/clappers",
            httpMethod: .delete
        ).request()
        return request.map { _ in () }.retryAuth()
    }

    /// お知らせへのコメント
    static func comment(_ notificationId: String, _ content: String) -> Observable<NotificationCommentData> {
        struct Param: Codable {
            let notificationComment: Comment
            enum CodingKeys: String, CodingKey {
                case notificationComment = "notification_comment"
            }
        }
        struct Comment: Codable {
            let content: String
        }
        struct Response: BaseModel {
            let data: ResponsedNotificationComment
            let included: [Included]
        }
        let request: Observable<Response> = APIRouter(
            path: "/notifications/\(notificationId)/notification_comments",
            httpMethod: .post,
            parameters: Param(notificationComment: Comment(content: content))
        ).request()
        return request.map { response in
            return NotificationCommentData(notificationComment: response.data, included: response.included)
        }.retryAuth()
    }
    /// お知らせへのファイル送信
    static func sendFile(_ notificationId: String, _ files: [URL]) -> Observable<NotificationCommentData> {
        struct Param: Codable {
            let notificationComment: Comment
            enum CodingKeys: String, CodingKey {
                case notificationComment = "notification_comment"
            }
        }
        struct Comment: Codable {
            let attachmentsAttributes: [Attachment]
            enum CodingKeys: String, CodingKey {
                case attachmentsAttributes = "attachments_attributes"
            }
        }
        struct Attachment: Codable {
            let name: String
            let file: String
        }
        struct Response: BaseModel {
            let data: ResponsedNotificationComment
            let included: [Included]
        }
        let request: Observable<Response> = APIRouter(
            path: "/notifications/\(notificationId)/notification_comments",
            httpMethod: .post,
            parameters: Param(notificationComment: Comment(attachmentsAttributes: files.compactMap {
                if let data = try? Data(contentsOf: $0), let ext = $0.lastPathComponent.split(separator: ".").last, let mimeType = String(ext).toMIMETypeFromExt() {
                    return Attachment(name: $0.lastPathComponent, file: "data:\(mimeType);base64,\(data.base64EncodedString())")
                }
                return nil
            }))
        ).request()
        return request.map { response in
            return NotificationCommentData(notificationComment: response.data, included: response.included)
        }.retryAuth()
    }
    /// お知らせへのスタンプ送信
    static func stamp(_ notificationId: String, _ id: String) -> Observable<NotificationCommentData> {
        struct Param: Codable {
            let notificationComment: Comment
            enum CodingKeys: String, CodingKey {
                case notificationComment = "notification_comment"
            }
        }
        struct Comment: Codable {
            let stamp: String
        }
        struct Response: BaseModel {
            let data: ResponsedNotificationComment
            let included: [Included]
        }
        let request: Observable<Response> = APIRouter(
            path: "/notifications/\(notificationId)/notification_comments",
            httpMethod: .post,
            parameters: Param(notificationComment: Comment(stamp: id))
        ).request()
        return request.map { response in
            return NotificationCommentData(notificationComment: response.data, included: response.included)
        }.retryAuth()
    }
}

// MARK: - 通報
extension NotificationsService {

    /// コメントの通報
    static func reportMessage(_ notification: NotificationData, _ notificationCOmment: NotificationCommentData, _ comment: String) -> Observable<Void> {
        struct Param: Codable {
            let notificationCommentReport: MessageReport
            enum CodingKeys: String, CodingKey {
                case notificationCommentReport = "notification_comment_report"
            }
        }
        struct MessageReport: Codable {
            let reportContent: String
            enum CodingKeys: String, CodingKey {
                case reportContent = "report_content"
            }
        }
        let param = Param(notificationCommentReport: MessageReport(reportContent: comment))
        let request: Observable<VoidResponse> = APIRouter(
            path: "/notifications/\(notification.notification.id)/notification_comments/\(notificationCOmment.notificationComment.id)/reports",
            httpMethod: .post,
            parameters: param
        ).request()
        return request.map { _ in () }.retryAuth()
    }
}
