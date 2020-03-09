//
//  MainInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import RxSwift
import SwiftEventBus
import ArrvisCore

// MARK: - MainInteractor
final class MainInteractor {

    // MARK: - Variables

    weak var output: MainInteractorOutputInterface?
}

// MARK: - MainInteractorInterface
extension MainInteractor: MainInteractorInterface {

    func loadData() {
        UserService.refreshLoginUser().flatMap { _ -> Observable<Void> in
            return Observable.zip(
                DepartmentService.refreshDepartments(),
                CoinService.refreshCoins(),
                resultSelector: { (_, _) -> Void in
                    return ()
                }
            )
        }.subscribe(onNext: { [unowned self] _ in
            self.output?.loadDataCompleted()
        }, onError: { [unowned self] error in
            self.output?.handleError(error, nil)
        }).disposed(by: self)

        _ = SwiftEventBus.onMainThread(self, SystemBusEvents.currentViewControllerChanged) { [weak self] _ in
            guard let nonNullSelf = self else {
                return
            }
            if UserService.loginUser == nil {
                // FIXME: ほんとはViewControllerのdeinit等から呼ぶべきだけど、破棄されない不具合のため暫定対応。
                SwiftEventBus.unregister(nonNullSelf)
                return
            }
            UserService.fetchBadgeCounts().subscribe(onNext: { [unowned self] footer in
                self?.output?.fetchBadgeCountsCompleted(footer)
            }, onError: { [unowned self] error in
                self?.output?.handleError(error, nil)
            }).disposed(by: nonNullSelf)
        }
    }
}
