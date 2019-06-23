//
//  AWSServiceCore.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/23.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import AWSCore

public typealias AWSConfig = (String, AWSRegionType)

/// AWSServiceコア
open class AWSServiceCore {

    /// 初期化
    public static func initialize(_ config: AWSConfig) {
        setDefaultConfig(config)
    }

    /// デフォルト設定
    public static func setDefaultConfig(_ config: AWSConfig) {
        AWSServiceManager.default()?.defaultServiceConfiguration = AWSServiceConfiguration(
            region: config.1,
            credentialsProvider: AWSCognitoCredentialsProvider(
                regionType: config.1,
                identityPoolId: config.0
            )
        )
    }
}
