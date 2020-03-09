//
//  AppButton.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import UIKit

/// Button
final class AppButton: UIButton {

    enum AppearanceType: String {
        case primary
        case lightNavyBordered
        case navyTransparent
        case darkGray
        case moveBlue
        case white
    }

    @IBInspectable var appearanceType: String = AppearanceType.primary.rawValue {
        didSet {
            backgroundColor = nil
            switch AppearanceType(rawValue: appearanceType)! {
            case .primary:
                setBackgroundColor(AppStyles.colorNavy, frame.size.height / 2, for: .normal)
                setTitleColor(AppStyles.colorWhite, for: .normal)
                layer.shadowColor = AppStyles.colorShadow.cgColor
                layer.shadowOpacity = 1
                layer.shadowRadius = 8
                layer.shadowOffset = CGSize(width: 0, height: 2)
            case .lightNavyBordered:
                setBackgroundColor(AppStyles.colorWhite, frame.size.height / 2, for: .normal)
                cornerRadius = frame.size.height / 2
                borderWidth = 2
                borderColor = AppStyles.colorLightNavy
                setTitleColor(AppStyles.colorDarkNavy, for: .normal)
            case .navyTransparent:
                setBackgroundColor(UIColor.clear, for: .normal)
                setTitleColor(AppStyles.colorNavy, for: .normal)
            case .darkGray:
                setBackgroundColor(AppStyles.colorWhite, frame.size.height / 2, for: .normal)
                setTitleColor(AppStyles.colorDarkGray, for: .normal)
                layer.shadowColor = AppStyles.colorShadow.cgColor
                layer.shadowOpacity = 1
                layer.shadowRadius = 10
                layer.shadowOffset = CGSize(width: 0, height: 2)
            case .moveBlue:
                setBackgroundColor(AppStyles.colorMoveBlue, frame.size.height / 2, for: .normal)
                setTitleColor(AppStyles.colorWhite, for: .normal)
                cornerRadius = frame.size.height / 2
            case .white:
                setBackgroundColor(AppStyles.colorWhite, frame.size.height / 2, for: .normal)
                cornerRadius = frame.size.height / 2
            }
        }
    }
}
