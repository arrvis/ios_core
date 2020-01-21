//
//  BaseNavigationController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/11/28.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

/// UINavigationController基底クラス
open class BaseNavigationController: UINavigationController, UINavigationControllerDelegate, ViewControllerProtocols {

    // MARK: - Variables

    /// Delegate
    open override var delegate: UINavigationControllerDelegate? {
        didSet {
            if (delegate as? BaseNavigationController) != self {
                fatalError("Not permitted")
            }
        }
    }

    /// 透明なNavigationBarかどうか
    open var transparentNavigationBar: Bool {
        return false
    }

    // MARK: - Life-Cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if transparentNavigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
        initializeForProtocols()
    }

    // MARK: - ExtendsViewControllerEventsHandleable

    /// 初回layoutSubviews
    open func onDidFirstLayoutSubviews() {}

    /// 次画面から戻ってきた
    ///
    /// - Parameter result: result
    open func onBackFromNext(_ result: Any?) {}

    // MARK: - BarButtonItemSettable

    /// 戻るBarButtonItem
    open var backBarButtonItem: UIBarButtonItem? { return navigationItem.backBarButtonItem }

    /// 左BarButtonItems
    open var leftBarButtonItems: [UIBarButtonItem]? { return navigationItem.leftBarButtonItems }

    /// 右BarButtonItems
    open var rightBarButtonItems: [UIBarButtonItem]? { return navigationItem.rightBarButtonItems }

    /// 戻るBarButtonItemタップ
    open func didTapBackBarButtonItem() {}

    /// 左BarButtonItemタップ
    open func didTapLeftBarButtonItem(_ index: Int) {}

    /// 右BarButtonItemタップ
    open func didTapRightBarButtonItem(_ index: Int) {}

    // MARK: - KeyboardDisplayable

    /// キーボード表示時にリサイズさせるScrollView
    open var scrollViewForResizeKeyboard: UIScrollView? { return nil }

    /// キーボード表示イベント
    open func onKeyboardWillShow(notification: Notification) {
        guard let scrollView = scrollViewForResizeKeyboard,
            let originInset = scrollViewForResizeKeyboard?.contentInset,
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        originContentInset = originContentInset ?? originInset
        let insets = UIEdgeInsets(
            top: originInset.top,
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
