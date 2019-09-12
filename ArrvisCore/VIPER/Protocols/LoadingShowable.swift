//
//  LoadingShowable.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit

public protocol LoadingShowable {
    func showLoading()
    func showLoading(message: String)
    func hideLoading()
}

extension LoadingShowable where Self: UIViewController {

    public func showLoading() {
        view.endEditing(true)
        if let superview = view.superview {
            ActivityIndicatorManager.shared.show(parent: superview)
        } else {
            NSObject.runAfterDelay(delayMSec: 100) { [unowned self] in
                self.showLoading()
            }
        }
    }

    public func showLoading(message: String) {
        view.endEditing(true)
        if let superview = view.superview {
            ActivityIndicatorManager.shared.show(parent: superview, message: message)
        } else {
            NSObject.runAfterDelay(delayMSec: 100) { [unowned self] in
                self.showLoading(message: message)
            }
        }
    }

    public func hideLoading() {
        ActivityIndicatorManager.shared.hide()
    }
}
