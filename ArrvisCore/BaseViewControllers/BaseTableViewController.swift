//
//  BaseTableViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/15.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift

/// UITableViewController基底クラス
open class BaseTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    // MARK: - Variables

    /// 戻るBarButtonItem
    open var backBarbuttonItem: UIBarButtonItem? {
        return nil
    }

    /// 左BarButtonItem
    open var leftBarbuttonItem: UIBarButtonItem? {
        return nil
    }

    /// 右BarButtonItem
    open var rightBarButtonItem: UIBarButtonItem? {
        return nil
    }

    /// キーボード表示時にリサイズさせるScrollView
    open var scrollViewForResizeKeyboard: UIScrollView? {
        return nil
    }

    private var originContentInset: UIEdgeInsets?
    private var keyboardSubscribers = [Disposable]()

    // MARK: - Events

    /// 初回SubViewsLayout
    open func onDidFirstLayoutSubviews() {}

    /// 戻るBarButtonItemタップ
    open func didTapBackBarButtonItem() {}

    /// 左BarButtonItemタップ
    open func didTapLeftBarButtonItem() {}

    /// 右BarButtonItemタップ
    open func didTapRightBarButtonItem() {}

    /// キーボード表示イベント
    open func onKeyboardWillShow(notification: Notification) {
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
    open func onKeyboardWillHide(notification: Notification) {
        guard let scrollView = scrollViewForResizeKeyboard,
            let originInset = originContentInset else {
                return
        }
        scrollView.contentInset = originInset
        scrollView.scrollIndicatorInsets = originInset
    }
}

// MARK: - Life-Cycle
extension BaseTableViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        if let backBarbuttonItem = backBarbuttonItem {
            navigationItem.backBarButtonItem = backBarbuttonItem
        }
        navigationItem.backBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] in
            self.didTapBackBarButtonItem()
        }).disposed(by: self)

        if let leftBarbuttonItem = leftBarbuttonItem {
            navigationItem.leftBarButtonItem = leftBarbuttonItem
        }
        navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] in
            self.didTapLeftBarButtonItem()
        }).disposed(by: self)

        if let rightBarButtonItem = rightBarButtonItem {
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] in
            self.didTapRightBarButtonItem()
        }).disposed(by: self)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        keyboardSubscribers = [
            NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillShowNotification)
                .subscribe(onNext: { [unowned self] notification in
                    self.onKeyboardWillShow(notification: notification)
                }
            ),
            NotificationCenter.default.rx
                .notification(UITextInputMode.currentInputModeDidChangeNotification)
                .subscribe(onNext: { [unowned self] notification in
                    self.onKeyboardWillShow(notification: notification)
                }
            ),
            NotificationCenter.default.rx
                .notification(UIResponder.keyboardWillHideNotification)
                .subscribe(onNext: { [unowned self] notification in
                    self.onKeyboardWillHide(notification: notification)
                }
            )
        ]
        keyboardSubscribers.forEach {$0.disposed(by: self)}
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didFirstLayoutSubviews {
            return
        }
        didFirstLayoutSubviews = true
        onDidFirstLayoutSubviews()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        keyboardSubscribers.forEach { sub in sub.dispose() }
        view.endEditing(true)
    }
}
