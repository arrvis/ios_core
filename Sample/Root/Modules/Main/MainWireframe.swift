//
//  MainWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/03.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - MainWireframe
final class MainWireframe: NSObject, MainWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.mainViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! MainViewController
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        presenter.payload = payload
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = MainWireframe()
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
