//
//  GroupServiceEx.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/02/25.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import RxSwift

// MARK: - 通報
extension GroupService {

    /// メッセージの通報
    static func reportMessage(_ group: GroupData, _ message: Message, _ comment: String) -> Observable<Void> {
        struct Param: Codable {
            let messageReport: MessageReport
            enum CodingKeys: String, CodingKey {
                case messageReport = "message_report"
            }
        }
        struct MessageReport: Codable {
            let reportContent: String
            enum CodingKeys: String, CodingKey {
                case reportContent = "report_content"
            }
        }
        let param = Param(messageReport: MessageReport(reportContent: comment))
        let request: Observable<VoidResponse> = APIRouter(
            path: "/groups/\(group.group.id)/messages/\(message.id)/reports",
            httpMethod: .post,
            parameters: param
        ).request()
        return request.map { _ in () }.retryAuth()
    }
}
