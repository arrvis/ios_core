//
//  SelectFontSizeWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 21/02/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SelectFontSizeWireframe
final class SelectFontSizeWireframe: NSObject, SelectFontSizeWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.selectFontSizeViewController.instantiateInitialViewController()!
        let vc = initialViewController
        let interactor = SelectFontSizeInteractor()
        let presenter = SelectFontSizePresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = SelectFontSizeWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
