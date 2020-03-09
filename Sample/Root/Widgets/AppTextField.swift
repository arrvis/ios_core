//
//  AppTextField.swift
//  ios_vue_apollo
//
//  Created by Yutaka Izumaru on 2019/06/25.
//  Copyright © 2019 Arrvis Co., Ltd. All rights reserved.
//

import UIKit
import ArrvisCore

/// TextField
class AppTextField: BaseTextField {

    enum AppearanceType: String {
        case bordered
        case normal
        case clear
    }

    @IBInspectable var appearanceType: String = AppearanceType.normal.rawValue {
        didSet {
            borderStyle = .none
            textColor = AppStyles.colorBlack
            clipsToBounds = true

            switch AppearanceType(rawValue: appearanceType)! {
            case .bordered:
                backgroundColor = AppStyles.colorWhite
                borderWidth = 2
                borderColor = AppStyles.colorTextViewBorder
            case .normal:
                backgroundColor = AppStyles.colorLightNavy
            case .clear:
                backgroundColor = UIColor.clear
            }
        }
    }

    override var barTintColor: UIColor? {
        return AppStyles.colorNavy
    }

    @IBInspectable var padding: CGPoint = CGPoint(x: 20, y: 0)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: self.padding.x, dy: self.padding.y)
    }
}
