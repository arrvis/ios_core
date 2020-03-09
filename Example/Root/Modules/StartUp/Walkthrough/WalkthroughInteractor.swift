//
//  WalkthroughInteractor.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

// MARK: - WalkthroughInteractor
final class WalkthroughInteractor {

    // MARK: - Variables

    weak var output: WalkthroughInteractorOutputInterface?
}

// MARK: - WalkthroughInteractorInterface
extension WalkthroughInteractor: WalkthroughInteractorInterface {

    func markAsRead() {
        UserService.didDisplayWalkthrough = true
        output?.markAsReadCompleted()
    }
}
