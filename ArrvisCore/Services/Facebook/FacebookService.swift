//
//  FacebookService.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/24.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift
import FBSDKLoginKit

/// Facebook関連サービス
public final class FacebookService {

    // MARK: - Application Delgates

    public static func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions)
    }

    public static func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
}

// MARK: - Auth
extension FacebookService {

    /// ログイン
    public static func login(_ permissions: [String], _ cancel: @escaping () -> Void) -> Observable<AccessToken> {
        return Observable.create({ observer in
            if let accessToken = AccessToken.current,
                permissions.first(where: { !accessToken.hasGranted(permission: $0)}) == nil {
                observer.onNext(accessToken)
            }
            let manager = LoginManager()
            manager.logIn(permissions: permissions, from: nil) { (result, error) in
                // https://github.com/facebook/facebook-swift-sdk/issues/201
                NSObject.runAfterDelay(delayMSec: 500) {
                    if let error = error {
                        logout()
                        observer.onError(error)
                        return
                    }
                    guard let result = result else {
                        logout()
                        observer.onError(AuthError())
                        return
                    }
                    if result.isCancelled {
                        cancel()
                        observer.onCompleted()
                    }
                    guard let token = result.token else {
                        logout()
                        observer.onError(AuthError())
                        return
                    }
                    observer.onNext(token)
                }
            }
            return Disposables.create()
        })
    }

    /// ログアウト
    public static func logout() {
        LoginManager().logOut()
    }
}
