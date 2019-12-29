//
//  LoadingShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

public protocol LoadingShowable {
    func showLoading(_ needFullScreen: Bool)
    func showLoading(message: String, _ needFullScreen: Bool)
    func hideLoading()
}

extension LoadingShowable where Self: UIViewController {

    public func showLoading(_ needFullScreen: Bool = false, _ usingSafeArea: Bool = false) {
        view.endEditing(true)
        if needFullScreen {
            ActivityIndicatorManager.shared.show(parent: UIApplication.shared.keyWindow!, usingSafeArea: usingSafeArea)
        } else if let superview = view.superview {
            ActivityIndicatorManager.shared.show(parent: superview, usingSafeArea: usingSafeArea)
        }
    }

    public func showLoading(message: String, _ needFullScreen: Bool = false, _ usingSafeArea: Bool = false) {
        view.endEditing(true)
        if needFullScreen {
            ActivityIndicatorManager.shared.show(
                parent: UIApplication.shared.keyWindow!,
                message: message,
                usingSafeArea: usingSafeArea)
        } else if let superview = view.superview {
            ActivityIndicatorManager.shared.show(parent: superview, message: message, usingSafeArea: usingSafeArea)
        }
    }

    public func hideLoading() {
        ActivityIndicatorManager.shared.hide()
    }
}
