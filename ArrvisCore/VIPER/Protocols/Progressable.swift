//
//  Progressable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

public protocol Progressable {
    func showLoading(_ parent: UIView)
    func showLoading(_ parent: UIView, message: String)
    func hideLoading()
}

extension Progressable where Self: UIViewController {

    public func showLoading(_ parent: UIView) {
        view.endEditing(true)
        ActivityIndicatorManager.shared.show(parent: parent)
    }

    public func showLoading(_ parent: UIView, message: String) {
        view.endEditing(true)
        ActivityIndicatorManager.shared.show(parent: parent, message: message)
    }

    public func hideLoading() {
        ActivityIndicatorManager.shared.hide()
    }
}
