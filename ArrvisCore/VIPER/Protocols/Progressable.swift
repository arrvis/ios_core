//
//  Progressable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

public protocol Progressable {
    func showLoading()
    func showLoading(message: String)
    func hideLoading()
}

extension Progressable where Self: UIViewController {

    public func showLoading() {
        view.endEditing(true)
        ActivityIndicatorManager.shared.show(parent: self.view)
    }

    public func showLoading(message: String) {
        view.endEditing(true)
        ActivityIndicatorManager.shared.show(parent: self.view, message: message)
    }

    public func hideLoading() {
        ActivityIndicatorManager.shared.hide()
    }
}
