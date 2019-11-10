//
//  ViewControllerProtocols.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/10/21.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

/// ViewController Protocol
protocol ViewControllerProtocols: ExtendsViewControllerEventsHandleable, BarButtonItemSettable, KeyboardDisplayable {}

extension ViewControllerProtocols {

    internal func initializeForProtocols() {
        rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).subscribe(onNext: { [unowned self] _ in
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.subscribeKeyboardEvents()
        }).disposed(by: self)
        rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).subscribe(onNext: { [unowned self] _ in
            self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            self.view.endEditing(true)
            self.unsubscribeKeyboardEvents()
        }).disposed(by: self)

        initViewControllerEventsHandler()
        initBarButtonItems()
    }
}
