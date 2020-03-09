//
//  CoinService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/28.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift

/// コインサービス
final class CoinService {

    // MARK: - Variables

    static var coins = [Coin]()

    // MARK: - Methods

    private struct CoinsResponse: BaseModel {
        let data: [Coin]
    }
    /// コイン一覧更新
    static func refreshCoins() -> Observable<Void> {
        let request: Observable<CoinsResponse> = APIRouter(path: "/coins").request()
        return request.map { ret in
            coins = ret.data
            return ()
        }.retryAuth()
    }
}
