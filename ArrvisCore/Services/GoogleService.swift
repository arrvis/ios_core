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
    private static let gidSignInHandler = GIDSignInHandler()
    private static var signInCancel = {}
    
    // MARK: - Application Delegates

    /// application
    static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let sourceApp = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApp, annotation: annotation)
    }
}

// MARK: - General
extension GoogleService {
    
    /// 初期化
    public static func initialize(_ delegate: GIDSignInUIDelegate) {
        GIDSignIn.sharedInstance().clientID = googleClientId
        GIDSignIn.sharedInstance().serverClientID = googleServerClientId
        GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/calendar"]
        GIDSignIn.sharedInstance().delegate = gidSignInHandler
        GIDSignIn.sharedInstance().uiDelegate = delegate
    }
}

// MARK: - Auth
extension GoogleService: NSObject, GIDSignInDelegate {
    
    /// Googleにログイン
    public static func login(_ cancel: @escaping () -> Void) -> Observable<GIDGoogleUser> {
        signInCancel = cancel
        return Observable.create { observer -> Disposable in
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
    static func logout() {
        googleRefreshToken = nil
        GIDSignIn.sharedInstance().disconnect()
    }
}

// MARK: - Calendar
extension GoogleService {
    
    /// スケジュールフェッチ
    static func fetchEvents(_ rangeYear: Int,
                            _ monthRange: Int,
                            _ lastSyncTime: Date?) -> Observable<[GoogleEvent]> {
        func fetchEvents(_ month: Date?) -> Observable<[GoogleEvent]> {
            return Observable.create({ observer in
                var path = "/events?"
                if let lastSyncTime = lastSyncTime?.plusMinute(TimeZone.current.secondsFromGMT() / 60) {
                    path += "updatedMin=\(lastSyncTime.toGoogleApiFormat())"
                } else if let month = month {
                    path += "timeMin=\(month.toGoogleApiFormat())&timeMax=\(month.plusMonth(1).toGoogleApiFormat())"
                }
                let request: Observable<GoogleEventsResponse> = GoogleCalendarAPIRouter(
                    path: path,
                    accessToken: GIDSignIn.sharedInstance().currentUser.authentication.accessToken,
                    httpMethod: .get).request()
                request.subscribe(onNext: { ret in
                    if !ret.items.isEmpty {
                        observer.onNext(ret.items)
                    }
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                }).disposed(by: disposeBag)
                return Disposables.create()
            })
        }
        if lastSyncTime == nil {
            var months = Date.getMonths(start: Date.now.startOfDay.plusMonth(-monthRange / 2),
                                        end: Date.now.startOfDay.plusMonth(monthRange / 2))
            months.append(contentsOf: Date.getMonths(start: Date.now.startOfDay.plusYear(-rangeYear),
                                                     end: Date.now.startOfDay.plusMonth(-monthRange / 2)))
            months.append(contentsOf: Date.getMonths(start: Date.now.startOfDay.plusMonth(monthRange / 2),
                                                     end: Date.now.startOfDay.plusYear(rangeYear)))
            return Observable.merge(months.map { fetchEvents($0)})
        } else {
            return fetchEvents(nil)
        }
    }
}

private class GIDSignInHandler: NSObject, GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        GoogleService.handleGoogleSignIn(user, error: error)
    }
}
