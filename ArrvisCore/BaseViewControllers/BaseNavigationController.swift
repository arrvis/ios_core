//
//  BaseNavigationController.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/11/28.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import SwiftEventBus

/// UINavigationController基底クラス
open class BaseNavigationController: UINavigationController,
BarButtonItemSettableViewController,
DidFirstLayoutSubviewsHandleable,
KeyboardDisplayableViewController {

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
}

// MARK: - UINavigationControllerDelegate
extension BaseNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        SwiftEventBus.post(SystemBusEvents.currentViewControllerChanged)
    }
}

// MARK: - Life-Cycle
extension BaseNavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        if transparentNavigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
        handleDidFirstLayoutSubviews()
    }

    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag) {
            completion?()
            SwiftEventBus.post(SystemBusEvents.currentViewControllerChanged)
        }
    }
}
