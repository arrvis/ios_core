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

    public func showLoading(_ needFullScreen: Bool = false) {
        view.endEditing(true)
        if needFullScreen {
            ActivityIndicatorManager.shared.show(parent: UIApplication.shared.keyWindow!)
        } else if let superview = view.superview {
            ActivityIndicatorManager.shared.show(parent: superview)
        }
    }

    public func showLoading(message: String, _ needFullScreen: Bool = false) {
        view.endEditing(true)
        if needFullScreen {
            ActivityIndicatorManager.shared.show(parent: UIApplication.shared.keyWindow!)
        } else if let superview = view.superview {
            ActivityIndicatorManager.shared.show(parent: superview, message: message)
        }
    }

    public func hideLoading() {
        ActivityIndicatorManager.shared.hide()
    }
}
