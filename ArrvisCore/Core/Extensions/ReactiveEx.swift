//
//  ReactiveEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2020/03/05.
//  Copyright © 2020 Arrvis Co., Ltd. All rights reserved.
//

import RxSwift

extension Reactive where Base: UITabBarController {
    public var selectedIndex: Observable<Int> {
        return self.observeWeakly(UIViewController.self, "selectedViewController")
            .flatMap { $0.map { Observable.just($0) } ?? Observable.empty()  }
            .flatMap { [weak base] in
                return base?.viewControllers?.firstIndex(of: $0).map { Observable.just($0) } ?? Observable.empty()
        }
    }
}
