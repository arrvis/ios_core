//
//  AttachmentPreviewInterfaces.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 15/02/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

protocol AttachmentPreviewViewInterface: ViewInterface {
    func showPreview(_ url: URL, _ canDownload: Bool)
}

protocol AttachmentPreviewPresenterInterface: PresenterInterface {
    func didTapDownload()
}

protocol AttachmentPreviewInteractorInterface: InteractorInterface {
}

protocol AttachmentPreviewInteractorOutputInterface: InteractorOutputInterface {
}

protocol AttachmentPreviewWireframeInterface: WireframeInterface {
}
