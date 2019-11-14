//
//  NotificationService.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/23.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import UserNotifications
import RxSwift
import SwiftEventBus

/// 通知関連サービス
open class NotificationService {

    // MARK: - Variables

    /// DeviceToken
    public static var deviceToken: String?

    private static let disposeBag = DisposeBag()
    private static var deviceTokenObserver: AnyObserver<String>?
}

// MARK: - Permission
extension NotificationService {

    /// 許可ステータス取得
    public static func fetchAuthorizationStatus() -> Observable<UNAuthorizationStatus> {
        return Observable.create({ observer in
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                observer.onNext(settings.authorizationStatus)
            }
            return Disposables.create()
        })
    }

    /// 許可リクエスト
    public static func requestAuthorization() -> Observable<Bool> {
        return Observable.create({ observer in
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
                NSObject.runOnMainThread {
                    if let error = error {
                        deviceToken = nil
                        observer.onError(error)
                    }
                    if error != nil {
                        observer.onNext(false)
                        observer.onCompleted()
                        return
                    }
                    if !granted {
                        deviceToken = nil
                    }
                    observer.onNext(granted)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        })
    }
}

// MARK: - Token
extension NotificationService {

    /// デバイストークン取得リクエスト
    public static func requestDeviceToken() -> Observable<String> {
        return Observable.create { observer in
            requestAuthorization().subscribe(onNext: { granted in
                if !granted {
                    observer.onCompleted()
                    return
                }
                deviceTokenObserver = observer
                NSObject.runOnMainThread {
                    UNUserNotificationCenter.current().delegate
                        = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }

    /// デバイストークン取得完了
    public static func didReceiveDeviceToken(_ deviceToken: Data) {
        self.deviceToken = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        deviceTokenObserver?.onNext(self.deviceToken!)
    }

    /// デバイストークン取得エラー
    public static func didErrorReceiveDeviceToken(_ error: Error) {
        deviceTokenObserver?.onError(error)
    }
}

// MARK: - Notification
extension NotificationService {

    /// リモート通知受信
    public static func didReceiveRemoteNotification(_ userInfo: [AnyHashable: Any]) {
        SwiftEventBus.post(SystemBusEvents.didReceiveRemoteNotification, sender: userInfo)
    }
}
