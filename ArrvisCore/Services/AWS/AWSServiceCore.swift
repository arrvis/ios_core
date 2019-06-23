//
//  AWSServiceCore.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/23.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import AWSCore

public struct SimplifiedAWSConfig {
    public let identityPoolId: String
    public let region: AWSRegionType

    func toAWSServiceConfiguration() -> AWSServiceConfiguration {
        return AWSServiceConfiguration(
            region: region,
            credentialsProvider: AWSCognitoCredentialsProvider(
                regionType: region,
                identityPoolId: identityPoolId
            )
        )
    }
}

/// AWSServiceコア
open class AWSServiceCore {

    /// 初期化
    public static func initialize(_ config: SimplifiedAWSConfig) {
        setDefaultConfig(config)
    }

    /// デフォルト設定
    public static func setDefaultConfig(_ config: SimplifiedAWSConfig) {
        AWSServiceManager.default()?.defaultServiceConfiguration = config.toAWSServiceConfiguration()
    }
}
