//
//  AttachmentPreviewWireframe.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 15/02/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - AttachmentPreviewWireframe
final class AttachmentPreviewWireframe: NSObject, AttachmentPreviewWireframeInterface {

    static func generateModule(_ payload: Any?) -> UIViewController {
        let initialViewController = R.storyboard.attachmentPreviewViewController.instantiateInitialViewController()!
        let vc = initialViewController.topViewController as! AttachmentPreviewViewController
        let interactor = AttachmentPreviewInteractor()
        let presenter = AttachmentPreviewPresenter()
        presenter.viewInterface = vc
        presenter.interactorInterface = interactor
        presenter.wireframeInterface = AttachmentPreviewWireframe()
        presenter.payload = payload
        interactor.output = presenter
        vc.presenterInterface = presenter
        return initialViewController
    }
}
