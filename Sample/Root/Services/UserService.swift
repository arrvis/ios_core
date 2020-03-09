//
//  UserService.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import RxSwift
import Alamofire
import AnyCodable

/// ユーザーサービス
final class UserService: NSObject {

    // MARK: - Variables

    /// ログイン認証済みかどうか
    static var isSignedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "UserService.isSignedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UserService.isSignedIn")
            UserDefaults.standard.synchronize()
        }
    }

    /// ログインID
    static var loginId: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserService.loginId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UserService.loginId")
            UserDefaults.standard.synchronize()
        }
    }

    /// ログインパスワード
    static var loginPassword: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserService.loginPassword")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UserService.loginPassword")
            UserDefaults.standard.synchronize()
        }
    }

    /// ログインユーザー
    static var loginUser: UserData?

    /// 許可取得画面を表示したかどうか
    static var didDisplayRequestPermissions: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "UserService.didDisplayRequestPermissions")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UserService.didDisplayRequestPermissions")
        }
    }

    /// ウォークスルーを表示したかどうか
    static var didDisplayWalkthrough: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "UserService.didDisplayWalkthrough")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "UserService.didDisplayWalkthrough")
        }
    }

    private static let disposeBag = DisposeBag()

    // MARK: - Methods

    /// サービス初期化
    static func initService() {
        LocationService.initService()
        FirebaseMessagingService.onRegistrationTokenChanged
            .subscribe(onNext: { fcmToken in
                if let fcmToken = fcmToken, isSignedIn {
                    registerDevices(fcmToken).subscribe().disposed(by: disposeBag)
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - 認証など
extension UserService {

    /// ログイン認証
    static func signIn(_ id: String, _ password: String) -> Observable<UserData> {
        HTTPCookieStorage.shared.cookies?.forEach({ cookie in
            HTTPCookieStorage.shared.deleteCookie(cookie)
        })
        struct Param: Codable {
            let signInId: String
            let password: String

            enum CodingKeys: String, CodingKey {
                case signInId = "sign_in_id"
                case password
            }
        }
        let request: Observable<(UserData, [AnyHashable: Any])> = APIRouter(
            path: "/auth/sign_in",
            httpMethod: .post,
            parameters: Param(signInId: id, password: password)).requestWithResponseHeaders()
        return request.map { response -> UserData in
            isSignedIn = true
            loginId = id
            loginPassword = password
            loginUser = response.0
            APIRouter.additionalHeaders = response.1 as! HTTPHeaders
            if let fcmToken = FirebaseMessagingService.fcmToken {
                registerDevices(fcmToken).subscribe().disposed(by: disposeBag)
            }
            return response.0
        }
    }

    // 再認証試行
    static func reSignIn() -> Single<UserData> {
        return signIn(loginId ?? "", loginPassword ?? "").asSingle()
    }

    /// サインアウト
    static func signOut() -> Observable<Void> {
        let request: Observable<VoidResponse> = APIRouter(
            path: "/auth/sign_out",
            httpMethod: .delete).request()
        return request.map { _ in
            HTTPCookieStorage.shared.cookies?.forEach({ cookie in
                HTTPCookieStorage.shared.deleteCookie(cookie)
            })
            APIRouter.additionalHeaders = [:]
            isSignedIn = false
            loginId = nil
            loginPassword = nil
            loginUser = nil
            appFontSize = .normal
            return ()
        }
    }
}

// MARK: - ユーザー情報など
extension UserService {

    /// ログインユーザー情報更新
    static func refreshLoginUser() -> Observable<Void> {
        let request: Observable<UserData> = APIRouter(path: "/users").request()
        return request.map { response -> Void in
            loginUser = response
            return ()
        }.retryAuth()
    }

    /// コメント更新
    static func updateComment(_ comment: String?) -> Observable<UserData> {
        struct Param: Codable {
            let user: UserParam
        }
        struct UserParam: Codable {
            let comment: String?
        }
        let request: Observable<VoidResponse> = APIRouter(
            path: "/users",
            httpMethod: .patch,
            parameters: Param(user: UserParam(comment: comment))).request()
        return request.flatMap { _ -> Observable<Void> in
            return refreshLoginUser()
        }.map { loginUser! }.retryAuth()
    }

    /// アイコン更新
    static func updateIcon(_ image: UIImage?) -> Observable<UserData> {
        struct Param: Codable {
            let user: UserParam
        }
        struct UserParam: Codable {
            let icon: String?
        }
        let request: Observable<VoidResponse> = APIRouter(
            path: "/users",
            httpMethod: .patch,
            parameters: Param(user: UserParam(icon: image?.resizeFit(minimumLength: 300).base64DataString))).request()
        return request.flatMap { _ -> Observable<Void> in
            return refreshLoginUser()
        }.map { loginUser! }.retryAuth()
    }

    private struct RegisterDevicesResponse: BaseModel {
        let data: Device
    }
    /// 現在ログインしているユーザーの端末情報の登録
    private static func registerDevices(_ fcmToken: String) -> Observable<Device> {
        struct Param: BaseModel {
            let device: DeviceParam
        }
        struct DeviceParam: BaseModel {
            let os = 0
            let fcmToken: String

            enum CodingKeys: String, CodingKey {
                case os
                case fcmToken = "fcm_token"
            }
        }
        let param = Param(device: DeviceParam(fcmToken: fcmToken))
        let request: Observable<RegisterDevicesResponse> = APIRouter(path: "/users/devices", httpMethod: .post, parameters: param).request()
        return request.map { $0.data }
    }

    private struct BadgeResponse: BaseModel {
        let data: FooterResponse
    }
    private struct FooterResponse: BaseModel {
        let footer: Footer
    }
    /// フッターバーに表示するバッジの情報取得
    static func fetchBadgeCounts() -> Observable<Footer> {
        let request: Observable<BadgeResponse> = APIRouter(path: "/users/footer").request()
        return request.map { ret in
            UIApplication.shared.applicationIconBadgeNumber = ret.data.footer.notReadMessagesCount + ret.data.footer.notReadNotificationsCount + (ret.data.footer.hasNewPresent ? 1 : 0)
            return ret.data.footer
        }.retryAuth()
    }
}

/// コインリストタイプ
enum CoinHistoryListType: String {
    case received
    case send
    case all
    case department
}

// MARK: - プレゼント
extension UserService {

    private struct PresentsResponse: BaseModel {
        let data: [Present]
        let included: [Included]
        let pagenation: Pagenation
    }
    /// そのユーザーに関するプレゼント履歴の表示
    static func fetchPresents(_ userId: String?, _ type: CoinHistoryListType, _ page: Int?) -> Observable<(
        data: [Present],
        coins: [Coin],
        users: [UserRelation],
        pagenation: Pagenation)> {
        let id = userId ?? loginUser!.data.id
        var path: String
        switch type {
        case .received:
            path = "/users/\(id)/presents?received=true"
        case .send:
            path = "/users/\(id)/presents?gave=true"
        case .all:
            path = "/presents"
        case .department:
            path = "/users/\(id)/presents?in_groups=true"
        }
        if let page = page {
            if path.contains("?") {
                path += "&page=\(page)"
            } else {
                path += "?page=\(page)"
            }
        }
        let request: Observable<PresentsResponse> = APIRouter(path: path).request()
        return request.map {
            let coins = $0.included.filter { $0.type == "coin" }
            let users = $0.included.filter { $0.type == "user" }
            return (
                data:$0.data,
                coins: coins.map { Coin.fromJson($0.jsonString!) },
                users: users.map { UserRelation.fromJson($0.jsonString!) },
                pagenation: $0.pagenation
            )
        }.retryAuth()
    }
}

// MARK: - 他人のプロフィール
extension UserService {

    /// ユーザー情報取得
    static func fetchUser(_ userId: String) -> Observable<UserData> {
        return APIRouter(path: "/users/\(userId)").request().retryAuth()
    }
}

extension Observable {

    func retryAuth() -> Observable<Element> {
        return retryWhen { errorObservable in
            return errorObservable.enumerated().flatMap({ (index, element) -> Single<Void> in
                if index >= 1 {
                    return .error(element)
                }
                return UserService.reSignIn().map { _ in
                    return ()
                }
            })
        }
    }
}
