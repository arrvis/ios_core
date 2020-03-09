//
//  FirebaseMessagingService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/15.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift
import Firebase

/// FirebaseMessagingサービス
public final class FirebaseMessagingService: NSObject {

    // MARK: - Variables

    /// 共有インスタンス
    static let shared: FirebaseMessagingService = FirebaseMessagingService()

    /// FCMトークン
    static var fcmToken: String? {
        didSet {
            onRegistrationTokenChangedSubject.onNext(fcmToken)
        }
    }

    /// FCMトークン変更
    static let onRegistrationTokenChanged: Observable<String?> = { onRegistrationTokenChangedSubject }()
    private static let onRegistrationTokenChangedSubject = { BehaviorSubject<String?>(value: fcmToken) }()

    private static let disposeBag = DisposeBag()
}

extension FirebaseMessagingService: MessagingDelegate, UNUserNotificationCenterDelegate {

    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        FirebaseMessagingService.fcmToken = fcmToken
    }

    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
}
