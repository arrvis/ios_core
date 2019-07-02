//
//  UIViewControllerEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/04/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private var disposeBagKey = 0
private var payloadKey = 1
private var didFirstLayoutSubviewsKey = 2

extension UIViewController: UIGestureRecognizerDelegate {

    /// SafeAreaInsets
    public var safeAreaInsets: UIEdgeInsets? {
        if #available(iOS 11, *) {
            if view.safeAreaInsets == .zero {
                return nil
            }
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }

    /// Payload
    public var payload: Any? {
        get {
            return objc_getAssociatedObject(self, &payloadKey)
        }
        set {
            objc_setAssociatedObject(self, &payloadKey, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let nav = self as? UINavigationController {
                nav.viewControllers.first?.payload = newValue
            }
            if let tab = self as? UITabBarController {
                tab.viewControllers?.forEach({ vc in
                    vc.payload = newValue
                })
            }
        }
    }

    /// Subviewの初回layoutが完了したか
    public var didFirstLayoutSubviews: Bool {
        get {
            return objc_getAssociatedObject(self, &didFirstLayoutSubviewsKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &didFirstLayoutSubviewsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    fileprivate var disposeBag: DisposeBag {
        get {
            guard let object = objc_getAssociatedObject(self, &disposeBagKey) as? DisposeBag else {
                self.disposeBag = DisposeBag()
                return self.disposeBag
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &disposeBagKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// PopGesture初期化
    func initializePopGesture() {
        rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).subscribe(onNext: { [unowned self] _ in
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }).disposed(by: self)
        rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).subscribe(onNext: { [unowned self] _ in
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            self.view.endEditing(true)
        }).disposed(by: self)
    }

    /// didFirstLayoutSubviewsハンドル
    func handleDidFirstLayoutSubviews() {
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews)).subscribe(onNext: { [unowned self] _ in
            if self.didFirstLayoutSubviews {
                return
            }
            self.didFirstLayoutSubviews = true
            (self as? DidFirstLayoutSubviewsHandleable)?.onDidFirstLayoutSubviews()
        }).disposed(by: self)
    }
}

extension Disposable {

    /// Disposed
    public func disposed(by: UIViewController) {
        self.disposed(by: by.disposeBag)
    }
}
