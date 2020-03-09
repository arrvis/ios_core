//
//  UserProfilePresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import ArrvisCore
import MobileCoreServices

// MARK: - UserProfilePresenter
final class UserProfilePresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: UserProfileInteractorInterface {
        return interactorInterface as! UserProfileInteractorInterface
    }

    private weak var view: UserProfileViewInterface? {
        return viewInterface as? UserProfileViewInterface
    }

    private var wireframe: UserProfileWireframeInterface {
        return wireframeInterface as! UserProfileWireframeInterface
    }

    private var user: UserData!

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchUser(getUserId())
    }
}

// MARK: - UserProfilePresenterInterface
extension UserProfilePresenter: UserProfilePresenterInterface {

    func getUserId() -> String {
        return payload as! String
    }

    func didTapSendCoin() {
        wireframe.showSendCoinScreen(user)
    }
}

// MARK: - UserProfileInteractorOutputInterface
extension UserProfilePresenter: UserProfileInteractorOutputInterface {

    func fetchUserCompleted(_ user: UserData) {
        self.user = user
        view?.showUser(user)
    }
}
