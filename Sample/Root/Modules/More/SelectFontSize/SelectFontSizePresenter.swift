//
//  SelectFontSizePresenter.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 21/02/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import ArrvisCore

// MARK: - SelectFontSizePresenter
final class SelectFontSizePresenter: PresenterBase {

    // MARK: - Variables

    private var interactor: SelectFontSizeInteractorInterface {
        return interactorInterface as! SelectFontSizeInteractorInterface
    }

    private weak var view: SelectFontSizeViewInterface? {
        return viewInterface as? SelectFontSizeViewInterface
    }

    private var wireframe: SelectFontSizeWireframeInterface {
        return wireframeInterface as! SelectFontSizeWireframeInterface
    }
}

// MARK: - SelectFontSizePresenterInterface
extension SelectFontSizePresenter: SelectFontSizePresenterInterface {
}

// MARK: - SelectFontSizeInteractorOutputInterface
extension SelectFontSizePresenter: SelectFontSizeInteractorOutputInterface {
}
