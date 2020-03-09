//
//  GroupCreationWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupCreationWireframe
final class GroupCreationWireframe: NSObject, GroupCreationWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.groupCreationViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = GroupCreationInteractor()
        let presenter = GroupCreationPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = GroupCreationWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showSelectMemberScreen(_ members: [UserData]) {
        navigator.navigate(screen: AppScreens.selectMember, payload: members)
    }
}
