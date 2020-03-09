//
//  SelectGroupWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 18/01/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SelectGroupWireframe
final class SelectGroupWireframe: NSObject, SelectGroupWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.selectGroupViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = SelectGroupInteractor()
        let presenter = SelectGroupPresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = SelectGroupWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
