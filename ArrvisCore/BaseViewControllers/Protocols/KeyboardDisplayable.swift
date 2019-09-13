//
//  KeyboardDisplayable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/07/02.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift

private var originalContentInsetKey = 0
private var keyboardSubscribersKey = 1
private var isKeyboardVisibleKey = 2

/// キーボード表示可能ViewController
public protocol KeyboardDisplayable where Self: UIViewController {

    /// キーボード表示時にリサイズさせるScrollView
    var scrollViewForResizeKeyboard: UIScrollView? { get }

    /// キーボード表示イベント
    func onKeyboardWillShow(notification: Notification)

    /// キーボード非表示イベント
    func onKeyboardWillHide(notification: Notification)
}

extension KeyboardDisplayable {

    /// キーボード表示時にリサイズさせるScrollView
    public var scrollViewForResizeKeyboard: UIScrollView? {
        return nil
    }

    /// キーボード表示状態
    public var isKeyboardVisible: Bool {
        get {
            return objc_getAssociatedObject(self, &isKeyboardVisibleKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &isKeyboardVisibleKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var originContentInset: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &originalContentInsetKey) as? UIEdgeInsets ?? nil
        }
        set {
            objc_setAssociatedObject(self, &originalContentInsetKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var keyboardSubscribers: [Disposable]? {
        get {
            return objc_getAssociatedObject(self, &keyboardSubscribersKey) as? [Disposable] ?? nil
        }
        set {
            objc_setAssociatedObject(self, &keyboardSubscribersKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    /// キーボード表示イベント
    public func onKeyboardWillShow(notification: Notification) {
        guard let scrollView = scrollViewForResizeKeyboard,
            let originInset = scrollViewForResizeKeyboard?.contentInset,
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        originContentInset = originContentInset ?? originInset
        let insets = UIEdgeInsets(top: originInset.top,
                                  left: originInset.left,
                                  bottom: keyboardFrame.height,
                                  right: originInset.right)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }

    /// キーボード非表示イベント
    public func onKeyboardWillHide(notification: Notification) {
        guard let scrollView = scrollViewForResizeKeyboard,
            let originInset = originContentInset else {
                return
        }
        scrollView.contentInset = originInset
        scrollView.scrollIndicatorInsets = originInset
    }

    func subscribeKeyboardEvents() {
        keyboardSubscribers = [
            NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillShowNotification)
                .subscribe(onNext: { [unowned self] notification in
                    self.isKeyboardVisible = true
                    self.onKeyboardWillShow(notification: notification)
                }
            ),
            NotificationCenter.default.rx
                .notification(UITextInputMode.currentInputModeDidChangeNotification)
                .subscribe(onNext: { [unowned self] notification in
                    self.isKeyboardVisible = true
                    self.onKeyboardWillShow(notification: notification)
                }
            ),
            NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillHideNotification)
                .subscribe(onNext: { [unowned self] notification in
                    self.isKeyboardVisible = false
                    self.onKeyboardWillHide(notification: notification)
                }
            )
        ]
        keyboardSubscribers?.forEach {$0.disposed(by: self)}
    }

    func unsubscribeKeyboardEvents() {
        keyboardSubscribers?.forEach { sub in sub.dispose() }
    }
}
