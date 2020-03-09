//
//  AppLabel.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/11/04.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import ArrvisCore
import TTTAttributedLabel

// Label
class AppLabel: InsetsSettableLabel {

    enum AppearanceType: String {
        case primary
        case navy
        case navyRounded
        case darkNavy
        case lightNavyRounded
        case darkGray
        case lineGrayRounded
        case blue
        case black
        case blackFewTransparent
        case blackHalfTransparent
        case blackMoreTransparent
        case badge
        case redRounded
        case lightBlueRounded
        case moveBlue
    }

    @IBInspectable var appearanceType: String = AppearanceType.primary.rawValue {
        didSet {
            switch AppearanceType(rawValue: appearanceType)! {
            case .primary:
                textColor = AppStyles.colorText // == darkNavy
            case .navy:
                textColor = AppStyles.colorNavy
            case .navyRounded:
                textColor = AppStyles.colorWhite
                backgroundColor = AppStyles.colorNavy
                clipsToBounds = true
                cornerRadius = 4
            case .darkNavy:
                textColor = AppStyles.colorDarkNavy
            case .lightNavyRounded:
                textColor = AppStyles.colorDarkGray
                backgroundColor = AppStyles.colorLightNavy
                clipsToBounds = true
                cornerRadius = frame.size.height / 2
            case .darkGray:
                textColor = AppStyles.colorDarkGray
            case .lineGrayRounded:
                textColor = AppStyles.colorWhite
                backgroundColor = AppStyles.colorLineGray
                clipsToBounds = true
                cornerRadius = 4
            case .blue:
                textColor = AppStyles.colorBlue
            case .black:
                textColor = UIColor.black
            case .blackFewTransparent:
                textColor = UIColor.black.withAlphaComponent(0.8)
            case .blackHalfTransparent:
                textColor = UIColor.black.withAlphaComponent(0.5)
            case .blackMoreTransparent:
                textColor = UIColor.black.withAlphaComponent(0.3)
            case .badge:
                textColor = AppStyles.colorWhite
                backgroundColor = AppStyles.colorRed
                clipsToBounds = true
                cornerRadius = frame.size.height / 2
            case .redRounded:
                textColor = AppStyles.colorWhite
                backgroundColor = AppStyles.colorRed
                clipsToBounds = true
                cornerRadius = 4
            case .lightBlueRounded:
                textColor = AppStyles.colorBlue
                backgroundColor = AppStyles.colorLightBlue
                clipsToBounds = true
                cornerRadius = 4
            case .moveBlue:
                textColor = AppStyles.colorMoveBlue
            }
        }
    }
}

open class LinkLabel: TTTAttributedLabel, TTTAttributedLabelDelegate {

    enum AppearanceType: String {
        case primary
        case darkGray
        case black
        case receivedMessage
        case sentMessage
    }

    @IBInspectable var appearanceType: String = AppearanceType.receivedMessage.rawValue {
        didSet {
            switch AppearanceType(rawValue: appearanceType)! {
            case .primary:
                textColor = AppStyles.colorText // == darkNavy
            case .darkGray:
                textColor = AppStyles.colorDarkGray
            case .black:
                textColor = UIColor.black
            case .receivedMessage:
                textColor = AppStyles.colorBlack
                backgroundColor = AppStyles.colorLightNavy
                linkAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                clipsToBounds = true
                cornerRadius = 12
            case .sentMessage:
                textColor = AppStyles.colorWhite
                backgroundColor = AppStyles.colorBlue
                linkAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                clipsToBounds = true
                cornerRadius = 12
            }
        }
    }

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initImpl()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initImpl()
    }

    private func initImpl() {
        enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        textInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        delegate = self
    }

    // MARK: - TTTAttributedLabelDelegate

    public func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    public func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        let url = URL(string: "tel://\(phoneNumber!)")!
        attributedLabel(label, didSelectLinkWith: url)
    }
}
