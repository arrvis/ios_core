//
//  InteractorInterfaceEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/08.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift

private var disposeBagKey = 0

extension InteractorInterface {

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
    public func disposed(by: InteractorInterface) {
        self.disposed(by: by.disposeBag)
    }
}
