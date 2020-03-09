//
//  SelectFontSizeViewController.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 21/02/2020.
//  Copyright © 2020 grabss corporation.. All rights reserved.
//

import UIKit

// MARK: - SelectFontSizeViewController
final class SelectFontSizeViewController: ViewBase {

    // MARK: - Variables

    private var presenter: SelectFontSizePresenterInterface {
        return presenterInterface as! SelectFontSizePresenterInterface
    }
}

// MARK: - SelectFontSizeViewInterface
extension SelectFontSizeViewController: SelectFontSizeViewInterface {
}
