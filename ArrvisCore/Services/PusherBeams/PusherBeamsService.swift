//
//  PusherBeamsService.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import SwiftEventBus
import PushNotifications

/// PusherBeamsサービス
public final class PusherBeamsService {

    /// PusherBeams初期化
    public static func initPusherBeams(_ instanceId: String, _ interests: [String]) {
        let pushNotifications = PushNotifications.shared
        pushNotifications.start(instanceId: instanceId)
        pushNotifications.registerForRemoteNotifications()
        interests.forEach { try! pushNotifications.addDeviceInterest(interest: $0) }
    }

    /// PusherBeams Interestsクリア
    public static func clearPusherBeamsDeviceInterests() {
        let pushNotifications = PushNotifications.shared
        try? pushNotifications.clearDeviceInterests()
    }

    /// デバイストークン取得完了
    public static func didReceiveDeviceToken(_ deviceToken: Data) {
        PushNotifications.shared.registerDeviceToken(deviceToken)
    }

    /// リモート通知受信
    public static func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        PushNotifications.shared.handleNotification(userInfo: userInfo)
        if let data = userInfo["data"], (data as? [AnyHashable: Any])?["pusher"] != nil {
            let pusher = PusherNotificationInfo.fromObject(userInfo)
            SwiftEventBus.post(SystemBusEvents.didReceivePusherRemoteNotification, sender: pusher)
        }
    }
}

public struct PusherNotificationInfo: BaseModel {
    public let data: PusherNotificationData
    public let aps: APS
}

public struct PusherNotificationData: BaseModel {
    public let pusher: Pusher
}

public struct Pusher: BaseModel {
    public let userShouldIgnore: Bool
    public let publishId: String
}

public struct APS: BaseModel {
    public let alert: Alert
    public let contentAvailable: Int

    enum CodingKeys: String, CodingKey {
        case alert
        case contentAvailable = "content-available"
    }
}

public struct Alert: BaseModel {
    public let title: String
    public let body: String
}
