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

    func handleDidFirstLayoutSubviews() {
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [unowned self] _ in
                (self as? DidFirstLayoutSubviewsHandleable)?.onDidFirstLayoutSubviews()
            }).disposed(by: self)
    }

    func initializePopGesture() {
        rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).subscribe(onNext: { [unowned self] _ in
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }).disposed(by: self)
        rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).subscribe(onNext: { [unowned self] _ in
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            self.view.endEditing(true)
        }).disposed(by: self)
    }

    func initializeBarButtonItemsIfNeed() {
        if let v = self as? BarButtonItemSettable {
            v.initBarButtonItems()
        }
    }

    func subscribeKeyboardEventsIfNeed() {
        if let v = self as? KeyboardDisplayable {
            v.subscribeKeyboardEvents()
        }
    }

    func unsubscribeKeyboardEventsIfNeed() {
        if let v = self as? KeyboardDisplayable {
            v.unsubscribeKeyboardEvents()
        }
    }
}

extension Disposable {

    /// Disposed
    public func disposed(by: UIViewController) {
        self.disposed(by: by.disposeBag)
    }
}
