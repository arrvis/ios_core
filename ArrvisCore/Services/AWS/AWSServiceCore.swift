//
//  AWSServiceCore.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/23.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import AWSCore

/// 簡易AWSServiceConfig
public struct SimplifiedAWSConfig {

    // MARK: - Variables

    /// IdentityPoolId
    public let identityPoolId: String

    // Region
    public let region: AWSRegionType

    // MARK: - Initializer

    public init(identityPoolId: String, region: AWSRegionType) {
        self.identityPoolId = identityPoolId
        self.region = region
    }

    // MARK: - Internal

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
public final class AWSServiceCore {

    /// 初期化
    public static func initialize(_ config: SimplifiedAWSConfig) {
        setDefaultConfig(config)
        AWSS3Service.initialize()
    }

    /// デフォルト設定
    public static func setDefaultConfig(_ config: SimplifiedAWSConfig) {
        AWSServiceManager.default()?.defaultServiceConfiguration = config.toAWSServiceConfiguration()
    }
}
