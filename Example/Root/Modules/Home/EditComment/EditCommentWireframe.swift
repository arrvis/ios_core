//
//  EditCommentWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 10/11/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - EditCommentWireframe
final class EditCommentWireframe: NSObject, EditCommentWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.editCommentViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! EditCommentViewController
        let interactor = EditCommentInteractor()
        let presenter = EditCommentPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = EditCommentWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
