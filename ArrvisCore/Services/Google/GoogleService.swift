//
//  GoogleService.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/06/24.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import Foundation
import RxSwift
import GoogleSignIn

/// Google関連サービス
public final class GoogleService {

    // MARK: - Constants

    public enum Scope: String {
        case calendar = "https://www.googleapis.com/auth/calendar"
    }

    // MARK: - Variables

    /// DisposeBag
    public static let disposeBag = DisposeBag()

    private static var googleRefreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "googleRefreshToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "googleRefreshToken")
        }
    }

    private static var googleAuthorizeObserver: AnyObserver<GIDGoogleUser>?
    private static var signInCancel = {}

    private static let gidSignInHandler = GIDSignInHandler()
    private class GIDSignInHandler: NSObject, GIDSignInDelegate {

        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            // https://github.com/facebook/facebook-swift-sdk/issues/201
            NSObject.runAfterDelay(delayMSec: 500) {
                GoogleService.handleGoogleSignIn(user, error: error)
            }
        }
    }

    // MARK: - Application Delegates

    /// application
    public static func application(_ app: UIApplication,
                                   open url: URL,
                                   options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let sourceApp = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApp, annotation: annotation)
    }
}

// MARK: - General
extension GoogleService {

    /// 初期化
    public static func initialize(_ clientId: String,
                                  _ serverClientId: String?,
                                  _ scopes: [Scope],
                                  _ delegate: GIDSignInUIDelegate) {
        GIDSignIn.sharedInstance().clientID = clientId
        if let serverClientId = serverClientId {
            GIDSignIn.sharedInstance().serverClientID = serverClientId
        }
        GIDSignIn.sharedInstance().scopes = scopes.map { $0.rawValue }
        GIDSignIn.sharedInstance().delegate = gidSignInHandler
        GIDSignIn.sharedInstance().uiDelegate = delegate
    }
}

// MARK: - Auth
extension GoogleService {

    /// Googleにログイン
    public static func login(_ cancel: @escaping () -> Void) -> Observable<GIDGoogleUser> {
        signInCancel = cancel
        return Observable.create { observer in
            googleAuthorizeObserver = observer
            if GIDSignIn.sharedInstance().currentUser == nil {
                NSObject.runOnMainThread {
                    GIDSignIn.sharedInstance().signIn()
                }
            } else {
                NSObject.runOnMainThread {
                    observer.onNext(GIDSignIn.sharedInstance().currentUser)
                }
            }
            return Disposables.create()
        }
    }

    /// Googleサインインハンドリング
    fileprivate static func handleGoogleSignIn(_ user: GIDGoogleUser!, error: Error!) {
        if let error = error as NSError? {
            // cancel
            if error.code == -5 {
                signInCancel()
                googleAuthorizeObserver?.onCompleted()
                return
            }
            googleAuthorizeObserver?.onError(error)
            return
        }

        googleRefreshToken = user.authentication.refreshToken
        googleAuthorizeObserver?.onNext(user)
    }

    /// Googleからログアウト
    public static func logout() {
        googleRefreshToken = nil
        GIDSignIn.sharedInstance()?.signOut()
    }
}

// MARK: - Calendar
extension GoogleService {

    /// カレンダーリストフェッチ
    public static func fetchCalendarList() -> Observable<[GoogleCalendar]> {
        return Observable.create { observer in
            guard let token = GIDSignIn.sharedInstance()?.currentUser.authentication.accessToken else {
                observer.onError(AuthError())
                return Disposables.create()
            }
            GoogleCalendarAPIRouter.fetchCalendarList(token, disposeBag).subscribe(onNext: { ret in
                observer.onNext(ret)
            }, onError: { error in
                observer.onError(error)
            }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }

    /// スケジュールフェッチ
    public static func fetchEvents(_ calendarId: String,
                                   _ rangeYear: Int,
                                   _ monthRange: Int,
                                   _ lastSyncTime: Date?) -> Observable<[GoogleEvent]> {
        return Observable.create { observer in
            guard let token = GIDSignIn.sharedInstance()?.currentUser.authentication.accessToken else {
                observer.onError(AuthError())
                return Disposables.create()
            }
            let observable: Observable<[GoogleEvent]>
            if lastSyncTime == nil {
                var months = Date.getMonths(start: Date.now.startOfDay.plusMonth(-monthRange / 2),
                                            end: Date.now.startOfDay.plusMonth(monthRange / 2))
                months.append(contentsOf: Date.getMonths(start: Date.now.startOfDay.plusYear(-rangeYear),
                                                         end: Date.now.startOfDay.plusMonth(-monthRange / 2)))
                months.append(contentsOf: Date.getMonths(start: Date.now.startOfDay.plusMonth(monthRange / 2),
                                                         end: Date.now.startOfDay.plusYear(rangeYear)))
                observable = Observable.merge(months.map {
                    GoogleCalendarAPIRouter.fetchEvents(calendarId, token, lastSyncTime, $0, disposeBag)
                })
            } else {
                observable = GoogleCalendarAPIRouter.fetchEvents(calendarId, token, lastSyncTime, nil, disposeBag)
            }
            observable.subscribe(onNext: { ret in
                observer.onNext(ret)
            }, onError: { error in
                observer.onError(error)
            }, onCompleted: {
                observer.onCompleted()
            }).disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}
