//
//  ReportMessageWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 19/12/2019.
//  Copyright © 2019 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - ReportMessageWireframe
final class ReportMessageWireframe: NSObject, ReportMessageWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.reportMessageViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! ReportMessageViewController
        let interactor = ReportMessageInteractor()
        let presenter = ReportMessagePresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = ReportMessageWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
