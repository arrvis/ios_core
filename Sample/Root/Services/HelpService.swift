//
//  HelpService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2020/03/04.
//  Copyright © 2020 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift

final class HelpService {

    // MARK: - Methods

    private struct HelpsResponse: BaseModel {
        let data: [ResponsedHelp]
        let included: [Included]
    }
    /// ヘルプ一覧の取得
    static func fetchHelps() -> Observable<[HelpData]> {
        let request: Observable<HelpsResponse> = APIRouter(path: "/helps").request()
        return request.map { ret -> [HelpData] in
            return ret.data.map { help -> HelpData in
                return HelpData(help: help, included: ret.included)
            }
        }.retryAuth()
    }
}
