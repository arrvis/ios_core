//
//  SelectMemberWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 23/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SelectMemberWireframe
final class SelectMemberWireframe: NSObject, SelectMemberWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.selectMemberViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = SelectMemberInteractor()
        let presenter = SelectMemberPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = SelectMemberWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }

    func showGroupCreationScreen(_ selectedMembers: [UserData]) {
        navigator.navigate(screen: AppScreens.groupCreation, payload: selectedMembers)
    }
}
