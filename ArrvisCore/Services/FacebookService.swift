//
//  FacebookService.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/24.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Foundation
import RxSwift
import FBSDKLoginKit

/// Facebook関連サービス
public final class FacebookService {

    // MARK: - Application Delgates

    public static func application(_ application: UIApplication,
                           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    public static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let sourceApp = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: sourceApp, annotation: annotation)
    }
}

extension FacebookService {

    /// ログイン
    public static func login(_ cancel: @escaping () -> Void) -> Observable<FBSDKAccessToken> {
        return Observable.create({ observer in
            if let accessToken = FBSDKAccessToken.current(), fbReadPermissions.first(where: { !accessToken.hasGranted($0)}) == nil {
                observer.onNext(accessToken)
            }
            let manager = FBSDKLoginManager()
            manager.loginBehavior = .browser
            manager.logIn(withReadPermissions: fbReadPermissions, from: nil) { (result, error) in
                if let error = error {
                    logout()
                    observer.onError(error)
                    return
                }
                guard let result = result else {
                    logout()
                    observer.onError(SNSError())
                    return
                }
                if result.isCancelled {
                    cancel()
                    observer.onCompleted()
                } else {
                    observer.onNext(result.token)
                }
            }
            return Disposables.create()
        })
    }

    /// ログアウト
    public static func logout() {
        FBSDKLoginManager().logOut()
    }
}
