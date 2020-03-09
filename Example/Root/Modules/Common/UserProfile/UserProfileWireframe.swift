//
//  UserProfileWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/02.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - UserProfileWireframe
final class UserProfileWireframe: NSObject, UserProfileWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.userProfileViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! UserProfileViewController
        let interactor = UserProfileInteractor()
        let presenter = UserProfilePresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = UserProfileWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showSendCoinScreen(_ user: UserData) {
        navigator.navigate(screen: AppScreens.sendCoin, payload: user)
    }
}
