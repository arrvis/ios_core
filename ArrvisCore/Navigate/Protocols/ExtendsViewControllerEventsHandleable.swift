//
//  ExtendsViewControllerEventsHandleable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/03/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import RxCocoa

/// 追加ViewControllerイベントハンドリング可能
protocol ExtendsViewControllerEventsHandleable where Self: UIViewController {

    /// 初回layoutSubviews
    func onDidFirstLayoutSubviews()

    /// 次画面から戻ってきた
    ///
    /// - Parameter result: result
    func onBackFromNext(_ result: Any?)
}

extension ExtendsViewControllerEventsHandleable {

    /// 初期化
    internal func initViewControllerEventsHandler() {
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.onDidFirstLayoutSubviews()
            }).disposed(by: self)
    }
}
