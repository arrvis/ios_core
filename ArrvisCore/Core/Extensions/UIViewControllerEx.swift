//
//  UIViewControllerEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/04/05.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift

private var disposeBagKey = 0

extension UIViewController: UIGestureRecognizerDelegate {

    /// SafeAreaInsets
    public var safeAreaInsets: UIEdgeInsets? {
        if #available(iOS 11, *) {
            if view.safeAreaInsets == .zero {
                return nil
            }
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }

    fileprivate var disposeBag: DisposeBag {
        get {
            guard let object = objc_getAssociatedObject(self, &disposeBagKey) as? DisposeBag else {
                self.disposeBag = DisposeBag()
                return self.disposeBag
            }
            return object
        }
        set {
            objc_setAssociatedObject(self, &disposeBagKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension Disposable {

    /// Disposed
    public func disposed(by: UIViewController) {
        self.disposed(by: by.disposeBag)
    }
}
