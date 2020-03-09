//
//  PresentsService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift

/// プレゼントサービス
final class PresentsService {

    // MARK: - Variables

    static var presents = [Present]()

    // MARK: - Methods

    /// プレゼント送信
    static func sendPresent(
        _ coinId: String,
        _ toId: String,
        _ pointNumber: Int,
        _ comment: String?) -> Observable<Void> {
        struct Param: Codable {
            let coinId: String
            let toId: String
            let pointNumber: Int
            let comment: String?

            enum CodingKeys: String, CodingKey {
                case coinId = "coin_id"
                case toId = "to_id"
                case pointNumber = "point_number"
                case comment
            }
        }
        let request: Observable<VoidResponse> = APIRouter(
            path: "/presents",
            httpMethod: .post,
            parameters: Param(coinId: coinId, toId: toId, pointNumber: pointNumber, comment: comment)
        ).request()
        return request.flatMap { _ -> Observable<Void> in
            return UserService.refreshLoginUser()
        }.map { _ in () }.retryAuth()
    }

    /// プレゼントへの拍手
    static func sendClap(_ presentId: String) -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/presents/\(presentId)/clappers",
            httpMethod: .post
        ).request()
        return request.map { _ in () }.retryAuth()
    }

    /// プレゼントへの拍手とりやめ
    static func deleteClap(_ presentId: String) -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/presents/\(presentId)/clappers",
            httpMethod: .delete
        ).request()
        return request.map { _ in () }.retryAuth()
    }

    /// プレゼントの確認
    static func markAsRead() -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/presents/checkers",
            httpMethod: .post
        ).request()
        return request.map { _ in () }.retryAuth()
    }
}
