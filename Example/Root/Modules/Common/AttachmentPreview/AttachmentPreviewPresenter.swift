//
//  AttachmentPreviewPresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 15/02/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore
import Alamofire

// MARK: - AttachmentPreviewPresenter
final class AttachmentPreviewPresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: AttachmentPreviewInteractorInterface {
        return interactorInterface as! AttachmentPreviewInteractorInterface
    }

    private weak var view: AttachmentPreviewViewInterface? {
        return viewInterface as? AttachmentPreviewViewInterface
    }

    private var wireframe: AttachmentPreviewWireframeInterface {
        return wireframeInterface as! AttachmentPreviewWireframeInterface
    }

    private var data: (URL, Bool) {
        return payload as! (URL, Bool)
    }

    // MARK: - Life-Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view?.showPreview(data.0, data.1)
    }
}

// MARK: - AttachmentPreviewPresenterInterface
extension AttachmentPreviewPresenter: AttachmentPreviewPresenterInterface {

    func didTapDownload() {
        view?.showLoading()
        Alamofire.request(APIRouter.generateHeaderAddedRequest(data.0.absoluteString)).response { [unowned self] res in
            self.view?.hideLoading()
            self.wireframe.showActivityScreen([res.data!], nil, nil)
        }
    }
}

// MARK: - AttachmentPreviewInteractorOutputInterface
extension AttachmentPreviewPresenter: AttachmentPreviewInteractorOutputInterface {
}
