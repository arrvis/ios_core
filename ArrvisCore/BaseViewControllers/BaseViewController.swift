//
//  BaseViewController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ios_extensions

// TODO: BaseViewControllerとBaseTableViewControllerとかまとめられるんじゃね？
/// UIViewController基底クラス
open class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Variables

    /// 戻るBarButtonItem
    open var backBarbuttonItem: UIBarButtonItem? {
        return nil
    }

    /// 左BarButtonItem
    open var leftBarbuttonItems: [UIBarButtonItem]? {
        return nil
    }

    /// 右BarButtonItem
    open var rightBarButtonItems: [UIBarButtonItem]? {
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
    open func didTapLeftBarButtonItem(_ index: Int) {}

    /// 右BarButtonItemタップ
    open func didTapRightBarButtonItem(_ index: Int) {}

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
extension BaseViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        if let backBarbuttonItem = backBarbuttonItem {
            navigationItem.backBarButtonItem = backBarbuttonItem
        }
        navigationItem.backBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] in
            self.didTapBackBarButtonItem()
        }).disposed(by: self)

        if let leftBarbuttonItems = leftBarbuttonItems {
            navigationItem.leftBarButtonItems = leftBarbuttonItems
        }
        navigationItem.leftBarButtonItems?.forEach({ item in
            item.rx.tap.subscribe(onNext: { [unowned self] in
                self.didTapLeftBarButtonItem(self.navigationItem.leftBarButtonItems!.firstIndex(of: item)!)
            }).disposed(by: self)
        })

        if let rightBarButtonItems = rightBarButtonItems {
            navigationItem.rightBarButtonItems = rightBarButtonItems
        }
        navigationItem.rightBarButtonItems?.forEach({ item in
            item.rx.tap.subscribe(onNext: { [unowned self] in
                self.didTapRightBarButtonItem(self.navigationItem.rightBarButtonItems!.firstIndex(of: item)!)
            }).disposed(by: self)
        })
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
