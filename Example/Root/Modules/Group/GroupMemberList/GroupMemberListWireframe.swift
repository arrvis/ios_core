//
//  GroupMemberListWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - GroupMemberListWireframe
final class GroupMemberListWireframe: NSObject, GroupMemberListWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.groupMemberListViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = GroupMemberListInteractor()
        let presenter = GroupMemberListPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = GroupMemberListWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
