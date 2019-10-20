//
//  BaseNavigator.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/09/14.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift
import Compass

/// Navigator基底クラス
open class BaseNavigator {

    // MARK: - Variables

    var replace: Observable<UIViewController> { return replaceSubject }
    private let replaceSubject = PublishSubject<UIViewController>()

    var push: Observable<(vc: UIViewController, fromRoot: Bool, animate: Bool)> { return pushSubject }
    private let pushSubject = PublishSubject<(vc: UIViewController, fromRoot: Bool, animate: Bool)>()

    var pop: Observable<(Any?, Bool)> { return popSubject }
    private let popSubject = PublishSubject<(Any?, Bool)>()

    var present: Observable<(vc: UIViewController, animate: Bool)> { return presentSubject }
    private let presentSubject = PublishSubject<(vc: UIViewController, animate: Bool)>()

    var dismiss: Observable<(Any?, Bool)> { return dismissSubject }
    private let dismissSubject = PublishSubject<(Any?, Bool)>()

    // MARK: - Initializer

    public init() {
        Navigator.scheme = scheme
        Navigator.routes = routes
        Navigator.handle = { [unowned self] location in
            let animate = location.arguments.keys.contains("Animate")
            let fromRoot = location.arguments.keys.contains("FromRoot")
            let screen = self.getScreen(path: location.path)
            let payload: Any?
            if location.payload == nil && !location.arguments.isEmpty {
                // アプリケーション側では使ってないがプッシュ通知経由で来たらargsが入ってる
                var args = location.arguments
                args.removeValue(forKey: "Animate")
                args.removeValue(forKey: "FromRoot")
                payload = args
            } else {
                payload = location.payload
            }
            let vc = screen.createViewController(payload)
            switch screen.transition {
            case .replace:
                self.replaceSubject.onNext(vc)
            case .push:
                self.pushSubject.onNext((vc: vc, fromRoot: fromRoot, animate: animate))
            case .present:
                self.presentSubject.onNext((vc: vc, animate: animate))
            }
        }
    }
}

// MARK: - Navigate
extension BaseNavigator {

    /// 遷移
    ///
    /// - Parameters:
    ///   - screen: スクリーン
    ///   - payload: ペイロード
    ///   - fromRoot: true:RootのNavigationControllerから遷移 false:カレントのNavigationControllerから遷移
    ///   - animate: アニメーションするかどうか
    public func navigate<T: Screen>(screen: T, payload: Any? = nil, fromRoot: Bool = false, animate: Bool = true) {
        var arg = [String: String]()
        if fromRoot {
            arg["FromRoot"] = "true"
        }
        if animate {
            arg["Animate"] = "true"
        }
        try! Navigator.navigate(location: Location(path: screen.path, arguments: arg, payload: payload))
    }

    /// 遷移
    ///
    /// - Parameter url: URL
    public func navigate(url: URL) {
        try! Navigator.navigate(url: url)
    }

    /// 戻る
    public func popScreen(result: Any? = nil, animate: Bool = true) {
        popSubject.onNext((result, animate))
    }

    /// スクリーンを非表示
    public func dismissScreen(result: Any? = nil, animate: Bool = true) {
        dismissSubject.onNext((result, animate))
    }
}

// MARK: - Navigatable
extension BaseNavigator: Navigatable {

    open var scheme: String {
        fatalError("Not implemented")
    }

    open var routes: [String] {
        fatalError("Not implemented")
    }

    open func getScreen(path: String) -> Screen {
        if let screen = SystemScreens(rawValue: path) {
            return screen
        }
        fatalError("Not implemented")
    }
}
