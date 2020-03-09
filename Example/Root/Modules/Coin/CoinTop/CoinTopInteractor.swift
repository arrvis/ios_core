//
//  CoinTopInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - CoinTopInteractor
final class CoinTopInteractor {

    // MARK: - Variables

    weak var output: CoinTopInteractorOutputInterface?
}

// MARK: - CoinTopInteractorInterface
extension CoinTopInteractor: CoinTopInteractorInterface {

    func markAsRead() {
        PresentsService.markAsRead().subscribe().disposed(by: self)
    }
}
